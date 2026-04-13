<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

use Spatie\Permission\Models\Role;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        /**
         * 1 Roles (Spatie)
         */
        $roleAdmin = Role::firstOrCreate(['name' => 'super-admin']);
        
        $roleStationUPAPKK = Role::firstOrCreate(['name' => 'station-upa-pkk']);

        /*
        |--------------------------------------------------------------------------
        | SEEDER KHUSUS KP
        |--------------------------------------------------------------------------
        */
        $admin = User::updateOrCreate(
            ['email' => 'admin@upa.printation'],
            [
                'name' => 'Super Administrator',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
            ]
        );
        if (!$admin->hasRole('super-admin')) {
            $admin->assignRole($roleAdmin);
        }

        $this->command?->info('✅ Super Admin UPA: admin@upa.printation / password');
        $stationupapkk = User::updateOrCreate(
            ['email' => 'kiosk@upa.printation'],
            [
                'name' => 'Kiosk UPA PKK',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
            ]
        );
        if (!$stationupapkk->hasRole('station-upa-pkk')) {
            $stationupapkk->assignRole($roleStationUPAPKK);
        }
        $this->command?->info('✅ Station Kiosk UPA: kiosk@upa.printation / password');

        $this->command?->info('✅ Seeder done');
    }
}
