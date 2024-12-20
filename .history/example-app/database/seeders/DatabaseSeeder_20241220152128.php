<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DepartmentAndPositionSeeder extends Seeder
{
    public function run()
    {
        $departments = [
            [
                'name' => 'Human Resources',
                'code' => 'HR',
                'description' => 'Manages employee relations, recruitment, and HR policies',
                'positions' => [
                    'HR Manager/Director',
                    'Recruiter',
                    'Training and Development Specialist',
                    'HR Generalist',
                    'Payroll Specialist',
                    'Benefits Coordinator',
                    'Employee Relations Specialist'
                ]
            ],
            [
                'name' => 'Finance and Accounting',
                'code' => 'FIN',
                'description' => 'Manages company finances and accounting operations',
                'positions' => [
                    'Chief Financial Officer (CFO)',
                    'Finance Manager',
                    'Accountant',
                    'Bookkeeper',
                    'Financial Analyst',
                    'Accounts Payable/Receivable Specialist',
                    'Tax Specialist'
                ]
            ],
            [
                'name' => 'Sales',
                'code' => 'SALES',
                'description' => 'Drives revenue through sales activities',
                'positions' => [
                    'Sales Manager/Director',
                    'Account Executive',
                    'Business Development Representative',
                    'Sales Associate/Representative',
                    'Key Account Manager',
                    'Sales Coordinator',
                    'Territory Manager'
                ]
            ],
            [
                'name' => 'Marketing',
                'code' => 'MKT',
                'description' => 'Handles brand management and marketing strategies',
                'positions' => [
                    'Chief Marketing Officer (CMO)',
                    'Marketing Manager',
                    'Content Strategist',
                    'Social Media Manager',
                    'Graphic Designer',
                    'SEO Specialist',
                    'Market Research Analyst',
                    'Brand Manager'
                ]
            ],
            [
                'name' => 'Operations',
                'code' => 'OPE',
                'description' => 'Handles brand management and marketing strategies',
                'positions' => [
                    'Chief Operating Officer (COO)',
                    'Operations Manager',
                    'Logistics Coordinator',
                    'Supply Chain Manager',
                    'Inventory Manager',
                    'Quality Assurance (QA) Officer',
                    'Process Improvement Specialist',
                    'Brand Manager'
                ]
            ],
            // ... continuing with more departments
        ];

        foreach ($departments as $dept) {
            $department = DB::table('departments')->insertGetId([
                'name' => $dept['name'],
                'code' => $dept['code'],
                'description' => $dept['description'],
                'created_at' => now(),
                'updated_at' => now()
            ]);

            foreach ($dept['positions'] as $position) {
                DB::table('positions')->insert([
                    'department_id' => $department,
                    'title' => $position,
                    'created_at' => now(),
                    'updated_at' => now()
                ]);
            }
        }
    }
}