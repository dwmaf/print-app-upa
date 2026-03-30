<?php

namespace App\Http\Controllers\InertiaControllers;

use App\Http\Controllers\Controller;
use App\Models\PrintRequest;
use App\Events\TransactionUpdated;
use Illuminate\Http\Request;
use Inertia\Inertia;

class InertiaVerifyPrintController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $printrequests = PrintRequest::with(['user', 'filetoprint'])
            ->when($search, function ($query, $search) {
                $query->where('request_id', 'like', "%{$search}%")
                    ->orWhereHas('filetoprint', function ($q) use ($search) {
                        $q->where('original_name', 'like', "%{$search}%");
                    });
            })
            ->latest()
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('VerifyPrint', [
            'printrequests' => $printrequests,
            'filters' => $request->only(['search']),
        ]);
    }

    public function verify($id)
    {
        $request = PrintRequest::findOrFail($id);
        $request->update([
            'status' => 'verified',
            'verified_at' => now(),
        ]);

        event(new TransactionUpdated($request->station_id));
        return redirect()->back();
    }

    public function reject($id)
    {
        $request = PrintRequest::findOrFail($id);
        $request->update([
            'status' => 'rejected',
        ]);

        event(new TransactionUpdated($request->station_id));
        return redirect()->back();
    }
}
