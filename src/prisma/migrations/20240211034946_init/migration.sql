-- CreateTable
CREATE TABLE `Revlog` (
    `lid` VARCHAR(191) NOT NULL,
    `cid` INTEGER NOT NULL,
    `grade` ENUM('0', '1', '2', '3', '4') NOT NULL,
    `state` ENUM('0', '1', '2', '3') NOT NULL,
    `due` DATETIME(3) NOT NULL,
    `stability` DOUBLE NOT NULL,
    `difficulty` DOUBLE NOT NULL,
    `elapsed_days` INTEGER NOT NULL,
    `last_elapsed_days` INTEGER NOT NULL,
    `scheduled_days` INTEGER NOT NULL,
    `review` DATETIME(3) NOT NULL,
    `duration` INTEGER NOT NULL DEFAULT 0,

    UNIQUE INDEX `Revlog_lid_key`(`lid`),
    INDEX `Revlog_cid_idx`(`cid`),
    PRIMARY KEY (`lid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Card` (
    `cid` INTEGER NOT NULL AUTO_INCREMENT,
    `due` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `stability` DOUBLE NOT NULL,
    `difficulty` DOUBLE NOT NULL,
    `elapsed_days` INTEGER NOT NULL,
    `scheduled_days` INTEGER NOT NULL,
    `reps` INTEGER NOT NULL,
    `lapses` INTEGER NOT NULL,
    `state` ENUM('0', '1', '2', '3') NOT NULL DEFAULT '0',
    `last_review` DATETIME(3) NULL,
    `nid` INTEGER NOT NULL,

    UNIQUE INDEX `Card_cid_key`(`cid`),
    UNIQUE INDEX `Card_nid_key`(`nid`),
    PRIMARY KEY (`cid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Parameters` (
    `uid` INTEGER NOT NULL AUTO_INCREMENT,
    `request_retention` DOUBLE NOT NULL DEFAULT 0.9,
    `maximum_interval` INTEGER NOT NULL DEFAULT 36500,
    `w` JSON NOT NULL,
    `enable_fuzz` BOOLEAN NOT NULL DEFAULT false,
    `card_limit` INTEGER NOT NULL DEFAULT 50,
    `lingq_token` VARCHAR(191) NULL,
    `lingq_counter` VARCHAR(191) NULL,

    UNIQUE INDEX `Parameters_uid_key`(`uid`),
    PRIMARY KEY (`uid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `User` (
    `uid` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `oauthId` VARCHAR(191) NOT NULL,
    `oauthType` VARCHAR(191) NOT NULL DEFAULT 'local',
    `email` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `User_uid_key`(`uid`),
    UNIQUE INDEX `User_name_key`(`name`),
    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`uid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Note` (
    `nid` INTEGER NOT NULL AUTO_INCREMENT,
    `uid` INTEGER NOT NULL,
    `question` VARCHAR(191) NOT NULL DEFAULT '',
    `answer` VARCHAR(191) NOT NULL DEFAULT '',
    `source` VARCHAR(191) NOT NULL DEFAULT '',
    `sourceId` VARCHAR(191) NULL,
    `extend` JSON NOT NULL,

    UNIQUE INDEX `Note_nid_key`(`nid`),
    INDEX `Note_uid_idx`(`uid`),
    INDEX `Note_sourceId_source_idx`(`sourceId`, `source`),
    PRIMARY KEY (`nid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Revlog` ADD CONSTRAINT `Revlog_cid_fkey` FOREIGN KEY (`cid`) REFERENCES `Card`(`cid`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Card` ADD CONSTRAINT `Card_nid_fkey` FOREIGN KEY (`nid`) REFERENCES `Note`(`nid`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_uid_fkey` FOREIGN KEY (`uid`) REFERENCES `Parameters`(`uid`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Note` ADD CONSTRAINT `Note_uid_fkey` FOREIGN KEY (`uid`) REFERENCES `User`(`uid`) ON DELETE RESTRICT ON UPDATE CASCADE;
