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
    Schema::create('salary_adjustments', function (Blueprint $table) {
        $table->id();
        $table->foreignId('employee_id')->constrained();
        $table->enum('type', ['bonus', 'deduction', 'overtime', 'allowance', 'tax']);
        $table->decimal('amount', 10, 2);
        $table->date('effective_date');
        $table->string('description');
        $table->enum('frequency', ['one_time', 'recurring']);
        $table->boolean('is_active')->default(true);
        $table->timestamps();
        $table->softDeletes();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('salary_adjustments');
    }
};
