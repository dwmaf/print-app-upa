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
        // PrintRequest::truncate();

        for ($i = 0; $i < 6; $i++) {
            $date = Carbon::now()->subMonths($i);
            
            // Buat 10-20 transaksi random per bulan
            for ($j = 0; $j < rand(10, 20); $j++) {
                PrintRequest::create([
                    'request_id' => 'REQ-' . strtoupper(bin2hex(random_bytes(3))),
                    'user_id' => 1, // Sesuaikan ID user
                    'station_id' => 2, // Sesuaikan ID station
                    'file_id' => 1,
                    'status' => 'completed',
                    'calculated_pages' => rand(1, 50),
                    'copies' => rand(1, 3),
                    'created_at' => $date->copy()->subDays(rand(1, 28)),
                ]);
            }
        }
    }
}