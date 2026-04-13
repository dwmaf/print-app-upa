<?php

namespace App\Http\Controllers\InertiaControllers;

use App\Events\NewRequestCreated;
use App\Events\RequestUpdated;
use App\Http\Controllers\Controller;
use App\Models\Filetoprint;
use App\Models\PrintRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

class InertiaPrintStationController extends Controller
{
    public function index(Request $request)
    {
        $uploadUrl = $request->getSchemeAndHttpHost() . '/upa/upload';
        $filetoprints = Filetoprint::with(['latestPrintRequest'])
            ->latest()
            ->get();
        $qrCode = QrCode::size(300)->margin(2)->generate($uploadUrl);
        return Inertia::render('PrintStation/index', [
            'filetoprints' => $filetoprints,
            'qrCode' => (string) $qrCode,
        ]);
    }

    public function submitRequest(Request $request)
    {
        $request->validate([
            'file_id' => 'required|exists:filetoprints,id',
            'print_config' => 'required|array',
        ]);

        $filetoprint = Filetoprint::find($request->file_id);

        $config = $request->print_config;
        $copies = $config['copies'] ?? 1;
        $isColor = ($config['color'] ?? 'bw') === 'color';
        $detectedPages = $config['detected_pages'] ?? 1;

        $actualPages = $detectedPages;
        if (isset($config['pages']) && $config['pages'] !== 'all') {
            $actualPages = 0;
            $parts = explode(',', str_replace(' ', '', $config['pages']));
            foreach ($parts as $part) {
                if (strpos($part, '-') !== false) {
                    $range = explode('-', $part);
                    if (count($range) === 2) {
                        $start = (int)$range[0];
                        $end = (int)$range[1];
                        if ($start > 0 && $end >= $start) {
                            $actualPages += ($end - $start + 1);
                        }
                    }
                } elseif (is_numeric($part)) {
                    $actualPages++;
                }
            }
            if ($actualPages === 0) $actualPages = $detectedPages;
        }

        $verification = PrintRequest::create([
            'request_id' => 'REQ-' . strtoupper(uniqid()),
            'filetoprint_id' => $filetoprint->id,
            'original_name' => $filetoprint->original_name,
            'status' => 'pending',
            'copies' => $copies,
            'color_mode' => $isColor ? 'color' : 'bw',
            'paper_size' => $config['paper'] ?? 'A4',
            'page_range' => $config['pages'] ?? 'all',
            'detected_pages' => $detectedPages,
            'calculated_pages' => $actualPages,
        ]);
        event(new NewRequestCreated());
        return redirect()->back();
    }

    public function print(Request $request)
    {
        $request->validate([
            'request_id' => 'required|exists:print_requests,id',
        ]);

        $verification = PrintRequest::findOrFail($request->request_id);
        $filetoprint  = Filetoprint::findOrFail($verification->filetoprint_id);

        $pdfPath = storage_path('app/public/' . $filetoprint->filename);
        if (!file_exists($pdfPath)) {
            return response()->json(['status' => 'error', 'message' => 'File tidak ditemukan.'], 404);
        }

        $exePath = base_path('tools/SumatraPDF.exe');
        if (file_exists($exePath)) {
            $settings = [];
            $settings[] = $verification->copies . "x";

            if ($verification->color_mode == 'bw') {
                $settings[] = "monochrome";
            } else {
                $settings[] = "color";
            }

            if (!empty($verification->paper_size)) {
                $settings[] = "paper=" . $verification->paper_size;
            }

            if (!empty($verification->page_range) && $verification->page_range !== 'all') {
                $settings[] = $verification->page_range;
            }

            $settingsString = implode(',', $settings);
            $command = "\"{$exePath}\" -print-to-default -print-settings \"{$settingsString}\" -silent \"{$pdfPath}\"";
            shell_exec($command);
        }

        $verification->update(['status' => 'completed']);
        event(new RequestUpdated());
        return response()->json([
            'status' => 'success',
            'message' => 'Perintah cetak terkirim.'
        ]);
    }

    public function destroy(Filetoprint $filetoprint)
    {
        if ($filetoprint->filename) {
            Storage::disk('public')->delete($filetoprint->filename);
        }

        $filetoprint->delete();

        return redirect()->back();
    }

    public function destroyMultiple(Request $request)
    {
        $request->validate([
            'file_ids' => 'required|array',
            'file_ids.*' => 'exists:filetoprints,id'
        ]);

        $filetoprints = Filetoprint::whereIn('id', $request->file_ids)->get();
        $count = $filetoprints->count();

        foreach ($filetoprints as $filetoprint) {
            if ($filetoprint->filename) {
                Storage::disk('public')->delete($filetoprint->filename);
            }
            $filetoprint->delete();
        }

        return redirect()->back()->with('success', $count . ' file berhasil dihapus.');
    }

    public function proxyPdf($id)
    {
        $file = Filetoprint::findOrFail($id);
        $path = storage_path('app/public/' . $file->filename);

        if (!file_exists($path)) {
            return response()->json(['error' => 'File not found'], 404);
        }

        // Membersihkan output buffer untuk mencegah file corrupt
        if (ob_get_length()) ob_end_clean();

        return response()->file($path, [
            'Content-Type' => 'application/pdf',
            'Access-Control-Allow-Origin' => '*',
            'Content-Disposition' => 'inline; filename="' . $file->original_name . '"',
            'Cache-Control' => 'no-cache, no-store, must-revalidate',
        ]);
    }
}
