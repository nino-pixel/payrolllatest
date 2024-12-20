<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    <?php

    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;
    
    return new class extends Migration
    {
        public function up()
        {
            Schema::create('positions', function (Blueprint $table) {
                $table->id();
                $table->foreignId('department_id')->constrained()->onDelete('cascade');
                $table->string('title');
                $table->text('description')->nullable();
                $table->timestamps();
            });
        }
    
        public function down()
        {
            Schema::dropIfExists('positions');
        }
    };

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('positions');
    }
};
