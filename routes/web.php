<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\VerifyPrintController;
use App\Http\Controllers\PrintStationController;
use App\Http\Controllers\UploadController;


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
    return redirect()->to('/login');
});

// AUTH
Route::group(['middleware' => 'guest'], function () {
    Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [AuthController::class, 'login'])->name('login.post');
});
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// (SUPER ADMIN)
Route::group(['middleware' => ['auth', 'role:super-admin']], function () {
    Route::get('/admin/upa/dashboard', [AuthController::class, 'dashboard'])->name('admin.upa.dashboard');
    Route::get('/admin/upa/verify-print', [VerifyPrintController::class, 'index'])->name('admin.upa.verify-print.index');
    Route::post('/admin/upa/verify-print/{id}', [VerifyPrintController::class, 'updateStatus'])->name('admin.upa.verify-print.action');
});

Route::group(['middleware' => ['auth', 'role:station-upa-pkk']], function () {
    Route::get('/upa/station', [PrintStationController::class, 'index'])->name('upa.station.index');
    Route::get('/station/proxy-pdf/{id}', [PrintStationController::class, 'proxyPdf'])->name('upa.station.proxy-pdf');
    Route::post('/upa/station/request-print', [PrintStationController::class, 'submitRequest'])->name('upa.station.request-print');
    Route::delete('/upa/station/file/{printfile}', [PrintStationController::class, 'destroy'])->name('upa.station.file.destroy');
    Route::delete('/upa/station/destroy-multiple', [PrintStationController::class, 'destroyMultiple'])->name('upa.station.destroy-multiple');
    Route::delete('/upa/station/destroy/{filetoprint}', [PrintStationController::class, 'destroy'])->name('upa.station.destroy');
    Route::post('/upa/station/print', [PrintStationController::class, 'print'])->name('upa.station.print');
});

// UPLOAD (USER)
Route::get('/upa/upload', [UploadController::class, 'index'])->name('upa.upload.index');
Route::post('/upa/upload', [UploadController::class, 'store'])->name('upa.upload.store');
