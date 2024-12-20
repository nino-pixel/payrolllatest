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
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('employee_id')->constrained();
            $table->date('date');
            $table->time('time_in');
            $table->time('time_out')->nullable();
            $table->enum('status', ['present', 'absent', 'late', 'half_day', 'on_leave']);
            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();
            
            // Ensure an employee can only have one attendance record per day
            $table->unique(['employee_id', 'date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attendances');
    }
};
