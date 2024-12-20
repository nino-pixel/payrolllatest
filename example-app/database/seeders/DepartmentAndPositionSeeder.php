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
                'code' => 'OPS',
                'description' => 'Manages day-to-day business operations',
                'positions' => [
                    'Chief Operating Officer (COO)',
                    'Operations Manager',
                    'Logistics Coordinator',
                    'Supply Chain Manager',
                    'Inventory Manager',
                    'Quality Assurance (QA) Officer',
                    'Process Improvement Specialist'
                ]
            ],
            [
                'name' => 'Information Technology',
                'code' => 'IT',
                'description' => 'Manages technology infrastructure and systems',
                'positions' => [
                    'Chief Information Officer (CIO)',
                    'IT Manager',
                    'Network Administrator',
                    'Systems Analyst',
                    'Cybersecurity Specialist',
                    'Help Desk Technician',
                    'Software Developer/Engineer',
                    'Database Administrator'
                ]
            ],
            [
                'name' => 'Customer Support',
                'code' => 'CS',
                'description' => 'Provides customer service and support',
                'positions' => [
                    'Customer Support Manager',
                    'Customer Service Representative',
                    'Call Center Agent',
                    'Technical Support Specialist',
                    'Customer Experience Manager',
                    'Help Desk Specialist',
                    'Retention Specialist'
                ]
            ],
            [
                'name' => 'Research and Development',
                'code' => 'RND',
                'description' => 'Focuses on innovation and product development',
                'positions' => [
                    'R&D Manager/Director',
                    'Research Scientist',
                    'Product Developer',
                    'Innovation Specialist',
                    'Laboratory Technician',
                    'Data Scientist'
                ]
            ],
            [
                'name' => 'Legal',
                'code' => 'LGL',
                'description' => 'Handles legal matters and compliance',
                'positions' => [
                    'General Counsel/Chief Legal Officer',
                    'Legal Advisor',
                    'Corporate Lawyer',
                    'Paralegal',
                    'Compliance Officer',
                    'Contract Manager',
                    'Intellectual Property Specialist'
                ]
            ],
            [
                'name' => 'Procurement',
                'code' => 'PROC',
                'description' => 'Manages purchasing and vendor relationships',
                'positions' => [
                    'Procurement Manager',
                    'Purchasing Agent',
                    'Vendor Manager',
                    'Inventory Controller',
                    'Sourcing Specialist',
                    'Procurement Analyst'
                ]
            ],
            [
                'name' => 'Administrative',
                'code' => 'ADMIN',
                'description' => 'Provides administrative support',
                'positions' => [
                    'Administrative Manager',
                    'Office Administrator',
                    'Executive Assistant',
                    'Receptionist',
                    'Data Entry Clerk',
                    'Office Coordinator'
                ]
            ],
            [
                'name' => 'Strategy and Business Development',
                'code' => 'SBD',
                'description' => 'Develops business strategies and growth plans',
                'positions' => [
                    'Chief Strategy Officer (CSO)',
                    'Business Development Manager',
                    'Strategic Planner',
                    'Partnership Manager',
                    'Market Expansion Analyst'
                ]
            ],
            [
                'name' => 'Engineering',
                'code' => 'ENG',
                'description' => 'Handles technical engineering work',
                'positions' => [
                    'Chief Engineer',
                    'Mechanical Engineer',
                    'Electrical Engineer',
                    'Civil Engineer',
                    'Software Engineer',
                    'Project Engineer',
                    'Design Engineer'
                ]
            ],
            [
                'name' => 'Quality Assurance',
                'code' => 'QA',
                'description' => 'Ensures quality standards and compliance',
                'positions' => [
                    'QA Manager',
                    'QA Analyst',
                    'QA Engineer',
                    'Test Engineer',
                    'Quality Inspector',
                    'Compliance Specialist'
                ]
            ],
            [
                'name' => 'Public Relations',
                'code' => 'PR',
                'description' => 'Manages public image and communications',
                'positions' => [
                    'PR Manager/Director',
                    'Media Relations Specialist',
                    'Communications Specialist',
                    'Event Coordinator',
                    'Publicist',
                    'Community Relations Manager'
                ]
            ],
            [
                'name' => 'Training and Development',
                'code' => 'TND',
                'description' => 'Manages employee training and development programs',
                'positions' => [
                    'Training Manager',
                    'Corporate Trainer',
                    'Instructional Designer',
                    'Learning and Development Specialist',
                    'E-Learning Developer',
                    'Training Coordinator'
                ]
            ]
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