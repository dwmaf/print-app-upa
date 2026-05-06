<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Models\PrintRequest;
use Carbon\Carbon;
use Inertia\Inertia;

class AuthController extends Controller
{
    public function showLoginForm()
    {
        return Inertia::render('Login');
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);
        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();
            /** @var \App\Models\User $user */
            $user = Auth::user();
            if ($user->hasRole('super-admin')) {
                return redirect()->route('admin.upa.dashboard');
            } elseif ($user->hasRole('station-upa-pkk')) {
                return redirect()->route('upa.station.index');
            }
            return redirect('/');
        }
        return back()->withErrors([
            'email' => 'Email atau password salah.',
        ]);
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('login');
    }

    public function dashboard()
    {
        $sheetsThisMonth = PrintRequest::where('status', 'completed')
            ->whereMonth('created_at', Carbon::now()->month)
            ->sum(DB::raw('calculated_pages * copies'));
        // Total Lembar Sepanjang Masa
        $sheetsAllTime = PrintRequest::where('status', 'completed')
            ->sum(DB::raw('calculated_pages * copies'));
        // Total Lembar Terprint Bulan Lalu (Untuk perbandingan trend)
        $sheetsLastMonth = PrintRequest::where('status', 'completed')
            ->whereMonth('created_at', Carbon::now()->subMonth()->month)
            ->sum(DB::raw('calculated_pages * copies'));
        // Persentase Trend
        $trendPercentage = 0;
        if ($sheetsLastMonth > 0) {
            $trendPercentage = (($sheetsThisMonth - $sheetsLastMonth) / $sheetsLastMonth) * 100;
        }
        // Status Overview
        $statusSummary = [
            'pending' => PrintRequest::where('status', 'pending')->count(),
            'verified' => PrintRequest::where('status', 'verified')->count(),
            'rejected' => PrintRequest::where('status', 'rejected')->count(),
        ];

        // Data Grafik Batang (6 Bulan Terakhir)
        $chartData = [];
        for ($i = 5; $i >= 0; $i--) {
            $month = Carbon::now()->subMonths($i);
            $total = PrintRequest::where('status', 'completed')
                ->whereMonth('created_at', $month->month)
                ->whereYear('created_at', $month->year)
                ->sum(DB::raw('calculated_pages * copies'));
            $chartData[] = [
                'month' => $month->translatedFormat('M Y'),
                'total' => (int) $total
            ];
        }
        return Inertia::render('DashboardAdmin', [
            'stats' => [
                'sheetsThisMonth' => number_format($sheetsThisMonth),
                'sheetsAllTime' => number_format($sheetsAllTime),
                'trendPercentage' => round($trendPercentage, 1) . '%',
                'statusSummary' => $statusSummary,
                'chartData' => $chartData,
            ]
        ]);
    }
}
