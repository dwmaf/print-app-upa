<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\InertiaControllers\InertiaAuthController;
use App\Http\Controllers\InertiaControllers\InertiaVerifyPrintController;
use App\Http\Controllers\InertiaControllers\InertiaPrintStationController;
use App\Http\Controllers\InertiaControllers\InertiaUploadController;


Route::get('/', function () {
    if (!Auth::check()) {
        return redirect()->route('login');
    }

    $user = Auth::user();
    
    if ($user->hasRole('super-admin')) {
        return redirect()->route('admin.upa.dashboard');
    } elseif ($user->hasRole('station-upa-pkk')) {
        return redirect()->route('upa.station.index');
    }

    return redirect()->to('/login'); // Fallback jika role tidak dikenali
});

/*
*/
// INERTIA AUTH
Route::group(['middleware' => 'guest'], function () {
    Route::get('/login', [InertiaAuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [InertiaAuthController::class, 'login'])->name('login.post');
});
Route::post('/logout', [InertiaAuthController::class, 'logout'])->name('logout');

// INERTIA AUTH (SUPER ADMIN)
Route::group(['middleware' => ['auth', 'role:super-admin']], function () {
    Route::get('/admin/upa/dashboard', [InertiaAuthController::class, 'dashboard'])->name('admin.upa.dashboard');
    Route::get('/admin/upa/verify-print', [InertiaVerifyPrintController::class, 'index'])->name('admin.upa.verify-print.index');
    Route::post('/admin/upa/verify-print/{id}', [InertiaVerifyPrintController::class, 'updateStatus'])->name('admin.upa.verify-print.action');
});

Route::group(['middleware' => ['auth', 'role:station-upa-pkk']], function () {
    Route::get('/upa/station', [InertiaPrintStationController::class, 'index'])->name('upa.station.index');
    Route::get('/station/proxy-pdf/{id}', [InertiaPrintStationController::class, 'proxyPdf'])->name('upa.station.proxy-pdf');
    Route::post('/upa/station/request-print', [InertiaPrintStationController::class, 'submitRequest'])->name('upa.station.request-print');
    Route::delete('/upa/station/file/{printfile}', [InertiaPrintStationController::class, 'destroy'])->name('upa.station.file.destroy');
    Route::delete('/upa/station/destroy-multiple', [InertiaPrintStationController::class, 'destroyMultiple'])->name('upa.station.destroy-multiple');
    Route::delete('/upa/station/destroy/{filetoprint}', [InertiaPrintStationController::class, 'destroy'])->name('upa.station.destroy');
    Route::post('/upa/station/print', [InertiaPrintStationController::class, 'print'])->name('upa.station.print');
});

// INERTIA UPLOAD (USER)
// buat kyu r nya dinamis berubah" setiap 5 menit
Route::get('/upa/upload', [InertiaUploadController::class, 'index'])->name('upa.upload.index');
Route::post('/upa/upload', [InertiaUploadController::class, 'store'])->name('upa.upload.store');
