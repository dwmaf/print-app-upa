<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PrintRequest;
use Carbon\Carbon;

class PrintRequestSeeder extends Seeder
{
    public function run(): void
    {
        // Hapus data lama jika perlu
        PrintRequest::truncate();

        for ($i = 0; $i < 6; $i++) {
            $monthDate = Carbon::now()->subMonths($i)->startOfMonth();
            $maxDays = ($i === 0) ? Carbon::now()->day - 1 : 27;
            if ($maxDays < 0) $maxDays = 0;
            // Buat 10-20 permintaan random per bulan
            for ($j = 0; $j < rand(10, 20); $j++) {
                PrintRequest::create([
                    'request_id' => 'REQ-' . strtoupper(bin2hex(random_bytes(3))),
                    'filetoprint_id' => 1,
                    'original_name' => 'dokumen_test_' . $j . '.pdf',
                    'status' => collect(['verified', 'completed'])->random(),
                    'calculated_pages' => rand(1, 50),
                    'copies' => rand(1, 3),
                    'color_mode' => rand(0, 1) ? 'bw' : 'color',
                    'created_at' => $monthDate->copy()->addDays(rand(0, $maxDays))->addHours(rand(8, 17)),
                ]);
            }
        }
    }
}