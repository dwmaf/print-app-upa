<?php

namespace App\Http\Controllers\InertiaControllers;

use App\Events\FileUploaded;
use App\Http\Controllers\Controller;
use App\Models\Filetoprint;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class InertiaUploadController extends Controller
{
    public function index()
    {
        return Inertia::render('UploadFile');
    }

    public function store(Request $request)
    {
        $request->validate([
            'files' => 'required|array|min:1',
            'files.*' => 'file|mimes:pdf,jpg,jpeg,png,docx|max:10240',
        ], [
            'files.*.max' => 'Ukuran file melebihi 10MB',
            'files.*.mimes' => 'Format file tidak didukung. Gunakan PDF, PNG, JPG, atau JPEG',
            'files.required' => 'Silakan pilih file untuk diunggah',
        ]);

        foreach ($request->file('files') as $uploadedFile) {
            $path = $uploadedFile->store('uploads', 'public');

            Filetoprint::create([
                'filename' => $path,
                'original_name' => $uploadedFile->getClientOriginalName(),
            ]);
        }

        event(new FileUploaded());

        return to_route('upa.upload.index')->with('success', 'File berhasil diunggah!');
    }
}
