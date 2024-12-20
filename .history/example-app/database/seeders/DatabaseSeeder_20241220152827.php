<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DepartmentAndPositionSeeder extends Seeder
{
    public function run()
    {
        $this->call([
            DepartmentAndPositionSeeder::class,
        ]);
    }
}