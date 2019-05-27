<?php

namespace UserFrosting\Sprinkle\Example\Database\Migrations;

use UserFrosting\Sprinkle\Core\Database\Migration;
use Illuminate\Database\Schema\Blueprint;

class CRMLink extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function up()
    {
        if (!$this->schema->hasTable('crmlink')) {
            $this->schema->create('crmlink', function (Blueprint $table) {
                $table->bigIncrements('id');
		$table->char('crm', 32);
                $table->char('crmid', 64);
                $table->string('crmtype', 64);
                $table->engine = 'InnoDB';
                $table->collation = 'utf8_unicode_ci';
                $table->charset = 'utf8';
                $table->index(['crm', 'crmid']);
            });
        }
    }

    /**
     * {@inheritdoc}
     */
    public function down()
    {
        $this->schema->drop('crmlink');
    }
}
