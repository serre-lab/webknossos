START TRANSACTION;

DROP VIEW webknossos.dataSets_;

ALTER TABLE webknossos.dataSets ADD COLUMN sourceDefaultConfiguration JSONB;

CREATE VIEW webknossos.dataSets_ AS SELECT * FROM webknossos.dataSets WHERE NOT isDeleted;

ALTER TABLE webknossos.dataSets ADD CONSTRAINT sourceDefaultConfigurationIsJsonObject CHECK(jsonb_typeof(sourceDefaultConfiguration) = 'object');

ALTER TABLE webknossos.dataSet_layers ADD COLUMN defaultViewConfiguration JSONB;
ALTER TABLE webknossos.dataSet_layers ADD CONSTRAINT defaultViewConfigurationIsJsonObject CHECK(jsonb_typeof(defaultViewConfiguration) = 'object');

-- Update alpha value of segmentation layer based on segmentationOpacity
UPDATE webknossos.datasets
SET defaultConfiguration = jsonb_set(
        defaultConfiguration,
        array['configuration','layers'],
        (defaultConfiguration->'configuration'->'layers')::jsonb || jsonb_build_object(dl.name, jsonb_build_object('alpha', defaultconfiguration->'configuration'->'segmentationOpacity')))
FROM webknossos.dataSet_layers dl
WHERE _id = dl._dataset and dl.category = 'segmentation' and defaultconfiguration->'configuration' ? 'segmentationOpacity';

-- Remove segmentationOpacityField
UPDATE webknossos.datasets
SET defaultConfiguration = jsonb_set(
        defaultConfiguration,
        array['configuration'],
        (defaultConfiguration->'configuration')::jsonb - 'segmentationOpacity')
WHERE defaultconfiguration->'configuration' ? 'segmentationOpacity';

UPDATE webknossos.releaseInformation SET schemaVersion = 51;

COMMIT TRANSACTION;

START TRANSACTION;

-- Update alpha value of segmentation layer based on segmentationOpacity
UPDATE webknossos.user_dataSetConfigurations
SET configuration = jsonb_set(
        configuration,
        array['layers'],
        (configuration->'layers')::jsonb || jsonb_build_object(dl.name, jsonb_build_object('alpha', configuration->'segmentationOpacity')))
FROM webknossos.dataSet_layers dl
WHERE webknossos.user_dataSetConfigurations._dataSet = dl._dataset and dl.category = 'segmentation' and configuration ? 'segmentationOpacity';

-- Remove segmentationOpacityField
UPDATE webknossos.user_dataSetConfigurations
SET configuration = configuration - 'segmentationOpacity'
WHERE configuration ? 'segmentationOpacity';

UPDATE webknossos.releaseInformation SET schemaVersion = 52;

COMMIT TRANSACTION;




START TRANSACTION;

DROP VIEW webknossos.dataStores_;

ALTER TABLE webknossos.dataStores ADD COLUMN allowsUpload BOOLEAN NOT NULL DEFAULT true;

CREATE VIEW webknossos.dataStores_ AS SELECT * FROM webknossos.dataStores WHERE NOT isDeleted;

UPDATE webknossos.releaseInformation SET schemaVersion = 53;

COMMIT TRANSACTION;



START TRANSACTION;

DROP VIEW webknossos.users_;

ALTER TABLE webknossos.users ADD COLUMN isDatasetManager BOOLEAN NOT NULL DEFAULT false;

UPDATE webknossos.users SET isDatasetManager = true WHERE _id IN (SELECT _user FROM webknossos.user_team_roles WHERE isTeamManager);

CREATE VIEW webknossos.users_ AS SELECT * FROM webknossos.users WHERE NOT isDeleted;

UPDATE webknossos.releaseInformation SET schemaVersion = 54;

COMMIT TRANSACTION;


START TRANSACTION;

ALTER TABLE webknossos.organizations ADD CONSTRAINT organizations_name_key UNIQUE (name);

UPDATE webknossos.releaseInformation SET schemaVersion = 55;

COMMIT TRANSACTION;


