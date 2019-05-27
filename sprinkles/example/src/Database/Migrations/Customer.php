<?php

namespace UserFrosting\Sprinkle\Example\Database\Migrations;

use UserFrosting\Sprinkle\Core\Database\Migration;
use Illuminate\Database\Schema\Blueprint;

class Customer extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function up()
    {
        if (!$this->schema->hasTable('customer')) {
            $this->schema->create('customer', function (Blueprint $table) {
                $table->bigIncrements('id');
		$table->string('name', 128);
                $table->bigInteger('crmlink');
                $table->string('phone', 32);
                $table->bigInteger('billingaddress');
                $table->bigInteger('shippingaddress');
                $table->bigInteger('salesrep');
                $table->bigInteger('techcontact');
                $table->bigInteger('billcontact');
                $table->bigInteger('portcontact');
                $table->bigInteger('defaultplan');
                $table->engine = 'InnoDB';
                $table->collation = 'utf8_unicode_ci';
                $table->charset = 'utf8';
            });
        }
    }

    /**
     * {@inheritdoc}
     */
    public function down()
    {
        $this->schema->drop('customer');
    }
}
