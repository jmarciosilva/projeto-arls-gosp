<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@gosp.org.br'],
            [
                'name' => 'Administrador da Plataforma',
                'role' => 'platform_admin',
                'lodge_id' => null,
                'member_id' => null,
                'password' => bcrypt('password'),
            ]
        );
    }
}
