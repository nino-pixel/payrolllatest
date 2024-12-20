<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
{
    Schema::create('payrolls', function (Blueprint $table) {
        $table->id();
        $table->foreignId('employee_id')->constrained();
        $table->string('payroll_id')->unique();
        $table->date('start_date');
        $table->date('end_date');
        $table->decimal('base_salary', 10, 2);
        $table->decimal('gross_salary', 10, 2);
        $table->decimal('total_deductions', 10, 2);
        $table->decimal('net_salary', 10, 2);
        $table->integer('total_working_days');
        $table->integer('days_worked');
        $table->integer('overtime_hours')->default(0);
        $table->decimal('overtime_pay', 10, 2)->default(0);
        $table->decimal('allowances', 10, 2)->default(0);
        $table->decimal('deductions', 10, 2)->default(0);
        $table->enum('status', ['draft', 'pending', 'approved', 'paid']);
        $table->date('payment_date')->nullable();
        $table->string('payment_method')->nullable();
        $table->text('notes')->nullable();
        $table->timestamps();
        $table->softDeletes();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payrolls');
    }
};
