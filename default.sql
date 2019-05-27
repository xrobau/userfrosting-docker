-- MySQL dump 10.16  Distrib 10.1.38-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: coredb    Database: userfrosting
-- ------------------------------------------------------
-- Server version	10.3.15-MariaDB-1:10.3.15+maria~bionic

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'An identifier used to track the type of activity.',
  `occurred_at` timestamp NULL DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activities_user_id_index` (`user_id`),
  CONSTRAINT `activities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (1,NULL,1,'sign_up','2019-05-01 00:00:00','User admin registered for a new account.');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'fa fa-user' COMMENT 'The icon representing users in this group.',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groups_slug_unique` (`slug`),
  KEY `groups_slug_index` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'terran','Terran','The terrans are a young species with psionic potential. The terrans of the Koprulu sector descend from the survivors of a disastrous 23rd century colonization mission from Earth.','sc sc-terran','2019-05-27 00:54:43','2019-05-27 00:54:43'),(2,'zerg','Zerg','Dedicated to the pursuit of genetic perfection, the zerg relentlessly hunt down and assimilate advanced species across the galaxy, incorporating useful genetic code into their own.','sc sc-zerg','2019-05-27 00:54:43','2019-05-27 00:54:43'),(3,'protoss','Protoss','The protoss, a.k.a. the Firstborn, are a sapient humanoid race native to Aiur. Their advanced technology complements and enhances their psionic mastery.','sc sc-protoss','2019-05-27 00:54:43','2019-05-27 00:54:43');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sprinkle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\ActivitiesTable',1),(2,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\GroupsTable',1),(3,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\PasswordResetsTable',1),(4,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\PermissionRolesTable',1),(5,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\RolesTable',1),(6,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\PermissionsTable',1),(7,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\PersistencesTable',1),(8,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\RoleUsersTable',1),(9,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\UsersTable',1),(10,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v400\\VerificationsTable',1),(11,'','\\UserFrosting\\Sprinkle\\Account\\Database\\Migrations\\v420\\AddingForeignKeys',1),(12,'','\\UserFrosting\\Sprinkle\\Core\\Database\\Migrations\\v400\\SessionsTable',1),(13,'','\\UserFrosting\\Sprinkle\\Core\\Database\\Migrations\\v400\\ThrottlesTable',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `hash` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `password_resets_user_id_index` (`user_id`),
  KEY `password_resets_hash_index` (`hash`),
  CONSTRAINT `password_resets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_roles`
--

DROP TABLE IF EXISTS `permission_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_roles` (
  `permission_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `permission_roles_permission_id_index` (`permission_id`),
  KEY `permission_roles_role_id_index` (`role_id`),
  CONSTRAINT `permission_roles_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `permission_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_roles`
--

LOCK TABLES `permission_roles` WRITE;
/*!40000 ALTER TABLE `permission_roles` DISABLE KEYS */;
INSERT INTO `permission_roles` VALUES (1,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(2,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(2,3,'2019-05-27 00:54:44','2019-05-27 00:54:44'),(3,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(4,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(5,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(6,1,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(7,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(8,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(9,3,'2019-05-27 00:54:44','2019-05-27 00:54:44'),(10,1,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(11,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(12,1,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(13,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(14,3,'2019-05-27 00:54:44','2019-05-27 00:54:44'),(15,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(16,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(17,3,'2019-05-27 00:54:44','2019-05-27 00:54:44'),(18,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(19,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(20,3,'2019-05-27 00:54:44','2019-05-27 00:54:44'),(21,2,'2019-05-27 00:54:43','2019-05-27 00:54:43'),(22,3,'2019-05-27 00:54:44','2019-05-27 00:54:44');
/*!40000 ALTER TABLE `permission_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'A code that references a specific action or URI that an assignee of this permission has access to.',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `conditions` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'The conditions under which members of this group have access to this hook.',
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'create_group','Create group','always()','Create a new group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(2,'create_user','Create user','always()','Create a new user in your own group and assign default roles.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(3,'create_user_field','Set new user group','subset(fields,[\'group\'])','Set the group when creating a new user.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(4,'delete_group','Delete group','always()','Delete a group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(5,'delete_user','Delete user','!has_role(user.id,2) && !is_master(user.id)','Delete users who are not Site Administrators.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(6,'update_account_settings','Edit user','always()','Edit your own account settings.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(7,'update_group_field','Edit group','always()','Edit basic properties of any group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(8,'update_user_field','Edit user','!has_role(user.id,2) && subset(fields,[\'name\',\'email\',\'locale\',\'group\',\'flag_enabled\',\'flag_verified\',\'password\'])','Edit users who are not Site Administrators.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(9,'update_user_field','Edit group user','equals_num(self.group_id,user.group_id) && !is_master(user.id) && !has_role(user.id,2) && (!has_role(user.id,3) || equals_num(self.id,user.id)) && subset(fields,[\'name\',\'email\',\'locale\',\'flag_enabled\',\'flag_verified\',\'password\'])','Edit users in your own group who are not Site or Group Administrators, except yourself.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(10,'uri_account_settings','Account settings page','always()','View the account settings page.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(11,'uri_activities','Activity monitor','always()','View a list of all activities for all users.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(12,'uri_dashboard','Admin dashboard','always()','View the administrative dashboard.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(13,'uri_group','View group','always()','View the group page of any group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(14,'uri_group','View own group','equals_num(self.group_id,group.id)','View the group page of your own group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(15,'uri_groups','Group management page','always()','View a page containing a list of groups.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(16,'uri_user','View user','always()','View the user page of any user.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(17,'uri_user','View user','equals_num(self.group_id,user.group_id) && !is_master(user.id) && !has_role(user.id,2) && (!has_role(user.id,3) || equals_num(self.id,user.id))','View the user page of any user in your group, except the master user and Site and Group Administrators (except yourself).','2019-05-27 00:54:43','2019-05-27 00:54:43'),(18,'uri_users','User management page','always()','View a page containing a table of users.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(19,'view_group_field','View group','in(property,[\'name\',\'icon\',\'slug\',\'description\',\'users\'])','View certain properties of any group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(20,'view_group_field','View group','equals_num(self.group_id,group.id) && in(property,[\'name\',\'icon\',\'slug\',\'description\',\'users\'])','View certain properties of your own group.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(21,'view_user_field','View user','in(property,[\'user_name\',\'name\',\'email\',\'locale\',\'theme\',\'roles\',\'group\',\'activities\'])','View certain properties of any user.','2019-05-27 00:54:43','2019-05-27 00:54:43'),(22,'view_user_field','View user','equals_num(self.group_id,user.group_id) && !is_master(user.id) && !has_role(user.id,2) && (!has_role(user.id,3) || equals_num(self.id,user.id)) && in(property,[\'user_name\',\'name\',\'email\',\'locale\',\'roles\',\'group\',\'activities\'])','View certain properties of any user in your own group, except the master user and Site and Group Administrators (except yourself).','2019-05-27 00:54:43','2019-05-27 00:54:43');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persistences`
--

DROP TABLE IF EXISTS `persistences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `persistences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `token` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `persistent_token` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `persistences_user_id_index` (`user_id`),
  KEY `persistences_token_index` (`token`),
  KEY `persistences_persistent_token_index` (`persistent_token`),
  CONSTRAINT `persistences_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persistences`
--

LOCK TABLES `persistences` WRITE;
/*!40000 ALTER TABLE `persistences` DISABLE KEYS */;
/*!40000 ALTER TABLE `persistences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_users`
--

DROP TABLE IF EXISTS `role_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_users` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_users_user_id_index` (`user_id`),
  KEY `role_users_role_id_index` (`role_id`),
  CONSTRAINT `role_users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `role_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_users`
--

LOCK TABLES `role_users` WRITE;
/*!40000 ALTER TABLE `role_users` DISABLE KEYS */;
INSERT INTO `role_users` VALUES (1,1,'2019-05-01 00:00:00','2019-05-01 00:00:00'),(1,2,'2019-05-01 00:00:00','2019-05-01 00:00:00'),(1,3,'2019-05-01 00:00:00','2019-05-01 00:00:00');
/*!40000 ALTER TABLE `role_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_slug_unique` (`slug`),
  KEY `roles_slug_index` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'user','User','This role provides basic user functionality.','2019-05-01 00:00:00','2019-05-01 00:00:00'),(2,'site-admin','Site Administrator','This role is meant for \"site administrators\", who can basically do anything except create, edit, or delete other administrators.','2019-05-01 00:00:00','2019-05-01 00:00:00'),(3,'group-admin','Group Administrator','This role is meant for \"group administrators\", who can basically do anything with users in their own group, except other administrators of that group.','2019-05-01 00:00:00','2019-05-01 00:00:00');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `payload` text COLLATE utf8_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  UNIQUE KEY `sessions_id_unique` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `throttles`
--

DROP TABLE IF EXISTS `throttles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `throttles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `request_data` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `throttles_type_index` (`type`),
  KEY `throttles_ip_index` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `throttles`
--

LOCK TABLES `throttles` WRITE;
/*!40000 ALTER TABLE `throttles` DISABLE KEYS */;
/*!40000 ALTER TABLE `throttles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `locale` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'en_US' COMMENT 'The language and locale to use for this user.',
  `theme` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The user theme.',
  `group_id` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'The id of the user group.',
  `flag_verified` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Set to 1 if the user has verified their account via email, 0 otherwise.',
  `flag_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Set to 1 if the user account is currently enabled, 0 otherwise.  Disabled accounts cannot be logged in to, but they retain all of their data and settings.',
  `last_activity_id` int(10) unsigned DEFAULT NULL COMMENT 'The id of the last activity performed by this user.',
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_name_unique` (`user_name`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_user_name_index` (`user_name`),
  KEY `users_email_index` (`email`),
  KEY `users_group_id_index` (`group_id`),
  KEY `users_last_activity_id_index` (`last_activity_id`),
  CONSTRAINT `users_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `users_last_activity_id_foreign` FOREIGN KEY (`last_activity_id`) REFERENCES `activities` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin@example.com','Admin','Users','en_US',NULL,1,1,1,6,'$2y$10$hlI1Lp3G3MjNdIH4Wc/L.O/gleSd4apU9q/B6TQiY6PlF./ZXonyu',NULL,'2019-05-01 00:00:00','2019-05-01 00:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verifications`
--

DROP TABLE IF EXISTS `verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `verifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `hash` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `verifications_user_id_index` (`user_id`),
  KEY `verifications_hash_index` (`hash`),
  CONSTRAINT `verifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verifications`
--

LOCK TABLES `verifications` WRITE;
/*!40000 ALTER TABLE `verifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `verifications` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-27 20:10:49
