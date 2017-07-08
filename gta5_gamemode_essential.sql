SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for bans
-- ----------------------------
DROP TABLE IF EXISTS `bans`;
CREATE TABLE `bans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `banned` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0',
  `banner` varchar(50) CHARACTER SET utf8mb4 NOT NULL,
  `reason` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bans
-- ----------------------------

-- ----------------------------
-- Table structure for coordinates
-- ----------------------------
DROP TABLE IF EXISTS `coordinates`;
CREATE TABLE `coordinates` (
  `identifier` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of coordinates
-- ----------------------------

-- ----------------------------
-- Table structure for items
-- ----------------------------
DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of items
-- ----------------------------
INSERT INTO `items` VALUES ('1', 'Bouteille d\'eau', '20', '1');
INSERT INTO `items` VALUES ('2', 'Sandwich', '20', '2');
INSERT INTO `items` VALUES ('3', 'Filet Mignon', '20', '2');
INSERT INTO `items` VALUES ('4', 'Cannabis', '0', '0');
INSERT INTO `items` VALUES ('5', 'Cannabis roulé', '0', '0');
INSERT INTO `items` VALUES ('6', 'Feuille Coka', '0', '0');
INSERT INTO `items` VALUES ('7', 'Coka', '0', '0');
INSERT INTO `items` VALUES ('8', 'Coka', '0', '0');
INSERT INTO `items` VALUES ('9', 'Ephedrine ', '0', '0');
INSERT INTO `items` VALUES ('10', 'Matière illégale', '0', '0');
INSERT INTO `items` VALUES ('11', 'Matière illégale', '0', '0');
INSERT INTO `items` VALUES ('12', 'Meth', '0', '0');
INSERT INTO `items` VALUES ('13', 'Organe', '0', '0');
INSERT INTO `items` VALUES ('14', 'Organe emballé', '0', '0');
INSERT INTO `items` VALUES ('15', 'Organe analysé', '0', '0');
INSERT INTO `items` VALUES ('16', 'Organe livrable', '0', '0');
INSERT INTO `items` VALUES ('17', 'Cuivre', '0', '0');
INSERT INTO `items` VALUES ('18', 'Fer', '0', '0');
INSERT INTO `items` VALUES ('19', 'Diamants', '0', '0');
INSERT INTO `items` VALUES ('20', 'Cuivre traité', '0', '0');
INSERT INTO `items` VALUES ('21', 'Fer traité', '0', '0');
INSERT INTO `items` VALUES ('22', 'Diamants traité', '0', '0');
INSERT INTO `items` VALUES ('23', 'Roche', '0', '0');
INSERT INTO `items` VALUES ('24', 'Roche traitée', '0', '0');
INSERT INTO `items` VALUES ('25', 'Poisson', '5', '2');
INSERT INTO `items` VALUES ('26', 'Corps', '0', '0');
INSERT INTO `items` VALUES ('27', 'Corps traité', '0', '0');

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `job_id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500',
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jobs
-- ----------------------------
INSERT INTO `jobs` VALUES ('1', 'Sans Emploi', '0');
INSERT INTO `jobs` VALUES ('2', 'Nettoyeur de piscine', '0');
INSERT INTO `jobs` VALUES ('3', 'Éboueur', '0');
INSERT INTO `jobs` VALUES ('4', 'Mineur', '0');
INSERT INTO `jobs` VALUES ('5', 'Chauffeur de taxi', '500');
INSERT INTO `jobs` VALUES ('6', 'Livreur de bois', '0');
INSERT INTO `jobs` VALUES ('7', 'Livreur de citerne', '0');
INSERT INTO `jobs` VALUES ('8', 'Livreur de conteneur', '0');
INSERT INTO `jobs` VALUES ('9', 'Livreur de médicament', '0');
INSERT INTO `jobs` VALUES ('10', 'Policier', '0');
INSERT INTO `jobs` VALUES ('11', 'Fossoyeur', '0');
INSERT INTO `jobs` VALUES ('12', 'Préposé à la morgue', '0');
INSERT INTO `jobs` VALUES ('13', 'Ambulancier', '500');
INSERT INTO `jobs` VALUES ('14', 'Depanneur', '0');

-- ----------------------------
-- Table structure for taxi
-- ----------------------------

CREATE TABLE `coffretaxi` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `solde` varchar(10) NOT NULL,
  `dirtysolde` varchar(10) NOT NULL,
  `lasttransfert` varchar(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `coffretaxi` (`id`, `identifier`, `solde`, `dirtysolde`, `lasttransfert`) VALUES
(1, '0', '500', '400', '10');

ALTER TABLE `coffretaxi`
  ADD PRIMARY KEY (`id`);
COMMIT;

-- ----------------------------
-- Table structure for Depanneur
-- ----------------------------

CREATE TABLE `coffredep` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `solde` varchar(10) NOT NULL,
  `dirtysolde` varchar(10) NOT NULL,
  `lasttransfert` varchar(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `coffredep` (`id`, `identifier`, `solde`, `dirtysolde`, `lasttransfert`) VALUES
(1, '0', '500', '400', '10');

ALTER TABLE `coffredep`
  ADD PRIMARY KEY (`id`);
COMMIT;


-- ----------------------------
-- Table structure for outfits
-- ----------------------------
DROP TABLE IF EXISTS `outfits`;
CREATE TABLE `outfits` (
  `identifier` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
  `skin` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'mp_m_freemode_01',
  `face` int(11) NOT NULL DEFAULT '0',
  `face_text` int(11) NOT NULL DEFAULT '0',
  `hair` int(11) NOT NULL DEFAULT '0',
  `hair_text` int(11) NOT NULL DEFAULT '0',
  `pants` int(11) NOT NULL DEFAULT '0',
  `pants_text` int(11) NOT NULL DEFAULT '0',
  `shoes` int(11) NOT NULL DEFAULT '0',
  `shoes_text` int(11) NOT NULL DEFAULT '0',
  `torso` int(11) NOT NULL DEFAULT '0',
  `torso_text` int(11) NOT NULL DEFAULT '0',
  `shirt` int(11) NOT NULL DEFAULT '0',
  `shirt_text` int(11) NOT NULL DEFAULT '0',
  `three` int(11) NOT NULL DEFAULT '0',
  `three_text` int(11) NOT NULL DEFAULT '0',
  `seven` int(11) NOT NULL DEFAULT '0',
  `seven_text` int(11) NOT NULL DEFAULT '0',
  `haircolor` int(11) NOT NULL DEFAULT '0',
  `haircolor_text` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of outfits
-- ----------------------------

-- ----------------------------
-- Table structure for phonebook
-- ----------------------------
DROP TABLE IF EXISTS `phonebook`;
CREATE TABLE `phonebook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pidentifier` varchar(30) CHARACTER SET utf8mb4 DEFAULT '',
  `phonenumber` varchar(30) CHARACTER SET utf8mb4 DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of phonebook
-- ----------------------------

-- ----------------------------
-- Table structure for police
-- ----------------------------
DROP TABLE IF EXISTS `police`;
CREATE TABLE `police` (
  `police_id` int(11) NOT NULL AUTO_INCREMENT,
  `police_name` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500',
  PRIMARY KEY (`police_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of police
-- ----------------------------
INSERT INTO `police` VALUES ('1', 'Cadet', '500');
INSERT INTO `police` VALUES ('2', 'Brigadier', '500');
INSERT INTO `police` VALUES ('3', 'Sergent', '500');
INSERT INTO `police` VALUES ('4', 'Lieutenant', '500');
INSERT INTO `police` VALUES ('5', 'Capitaine', '500');
INSERT INTO `police` VALUES ('6', 'Commandant', '500');
INSERT INTO `police` VALUES ('7', 'Colonel', '500');
INSERT INTO `police` VALUES ('8', 'Rien', '0');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `group` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0',
  `permission_level` int(11) NOT NULL DEFAULT '0',
  `money` double NOT NULL DEFAULT '0',
  `bankbalance` int(32) DEFAULT '0',
  `job` int(11) DEFAULT '1',
  `police` int(11) DEFAULT '0',
  `enService` int(11) DEFAULT '0',
  `dirtymoney` double(11,0) NOT NULL DEFAULT '0',
  `isFirstConnection` int(11) DEFAULT '1',
  `nom` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `prenom` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `telephone` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------

-- ----------------------------
-- Table structure for user_inventory
-- ----------------------------
DROP TABLE IF EXISTS `user_inventory`;
CREATE TABLE `user_inventory` (
  `user_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `item_id` int(11) unsigned NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`item_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `user_inventory_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_inventory
-- ----------------------------

-- ----------------------------
-- Table structure for user_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `user_vehicle`;
CREATE TABLE `user_vehicle` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
  `vehicle_name` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `vehicle_model` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `vehicle_price` int(60) DEFAULT NULL,
  `vehicle_plate` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `vehicle_state` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `vehicle_colorprimary` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `vehicle_colorsecondary` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `vehicle_pearlescentcolor` varchar(60) CHARACTER SET utf8mb4 NOT NULL,
  `vehicle_wheelcolor` varchar(60) CHARACTER SET utf8mb4 NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_vehicle
-- ----------------------------

-- ----------------------------
-- Table structure for user_weapons
-- ----------------------------
DROP TABLE IF EXISTS `user_weapons`;
CREATE TABLE `user_weapons` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
  `weapon_model` varchar(60) CHARACTER SET utf8mb4 NOT NULL,
  `withdraw_cost` int(10) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_weapons
-- ----------------------------
