<?php

namespace App\Http\Controllers\InertiaControllers;

use App\Http\Controllers\Controller;
use App\Models\PrintRequest;
use App\Events\RequestUpdated;
use Illuminate\Http\Request;
use Inertia\Inertia;

class InertiaVerifyPrintController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $printrequests = PrintRequest::with(['filetoprint'])
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

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'action' => 'required|in:verify,reject'
        ]);

        $printRequest = PrintRequest::findOrFail($id);

        $data = $request->action === 'verify'
            ? ['status' => 'verified', 'verified_at' => now()]
            : ['status' => 'rejected'];

        $printRequest->update($data);

        event(new RequestUpdated());
        return redirect()->back();
    }
}
