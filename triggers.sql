-- nws_owner_company triggers
DELIMITER //
CREATE TRIGGER trg_nws_owner_company_insert BEFORE INSERT ON nws_owner_company
FOR EACH ROW
BEGIN
    IF NEW.CompanyID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CompanyID must be a non-negative integer.';
    END IF;
    IF EXISTS (SELECT 1 FROM nws_owner_company WHERE CompanyID = NEW.CompanyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CompanyID already exists in nws_owner_company.';
    END IF;
END//

CREATE TRIGGER trg_nws_owner_company_update BEFORE UPDATE ON nws_owner_company
FOR EACH ROW
BEGIN
    IF NEW.CompanyID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CompanyID must be a non-negative integer.';
    END IF;
END//

CREATE TRIGGER trg_nws_owner_company_delete BEFORE DELETE ON nws_owner_company
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM nws_registry_card WHERE OwnerCompanyID = OLD.CompanyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Must remove/edit all associated nws storages before removing the owner company.';
    END IF;
END//

-- licensed_servicing_agency triggers
CREATE TRIGGER trg_licensed_servicing_agency_insert BEFORE INSERT ON licensed_servicing_agency
FOR EACH ROW
BEGIN
    IF NEW.AgencyID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'AgencyID must be a non-negative integer.';
    END IF;
    IF EXISTS (SELECT 1 FROM licensed_servicing_agency WHERE AgencyID = NEW.AgencyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'AgencyID already exists in licensed_servicing_agency.';
    END IF;
END//

CREATE TRIGGER trg_licensed_servicing_agency_update BEFORE UPDATE ON licensed_servicing_agency
FOR EACH ROW
BEGIN
    IF NEW.AgencyID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'gencyID must be a non-negative integer.';
    END IF;
END//

CREATE TRIGGER trg_licensed_servicing_agency_delete BEFORE DELETE ON licensed_servicing_agency
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM storage_certificate WHERE ServicingAgencyID = OLD.AgencyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can\'t remove servicing agency, there are certificates connected to it.';
    END IF;
    IF EXISTS (SELECT 1 FROM nws_registry_card WHERE ServicingAgencyID = OLD.AgencyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can\'t remove servicing agency, there are nws storages connected to it.';
    END IF;
END//

-- storage_certificate triggers
CREATE TRIGGER trg_storage_certificate_insert BEFORE INSERT ON storage_certificate
FOR EACH ROW
BEGIN
    IF NEW.CertificateID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CertificateID must be a non-negative integer.';
    END IF;
    IF EXISTS (SELECT 1 FROM storage_certificate WHERE CertificateID = NEW.CertificateID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CertificateID already exists in storage_certificate.';
    END IF;
END//

CREATE TRIGGER trg_storage_certificate_update BEFORE UPDATE ON storage_certificate
FOR EACH ROW
BEGIN
    IF NEW.CertificateID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CertificateID must be a non-negative integer.';
    END IF;
END//

CREATE TRIGGER trg_storage_certificate_delete BEFORE DELETE ON storage_certificate
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM nws_registry_card WHERE CertificateID = OLD.CertificateID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can\'t remove certificate, it is connected to nws storages.';
    END IF;
END//

-- nws_location triggers
CREATE TRIGGER trg_nws_location_insert BEFORE INSERT ON nws_location
FOR EACH ROW
BEGIN
    IF NEW.LocationID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LocationID must be a non-negative integer.';
    END IF;
    IF EXISTS (SELECT 1 FROM nws_location WHERE LocationID = NEW.LocationID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LocationID already exists in nws_location.';
    END IF;
    IF NEW.Latitude <= -90 OR NEW.Latitude > 90 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Latitude must be between -90 and 90.';
    END IF;
    IF NEW.Longitude <= -180 OR NEW.Longitude > 180 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Longitude must be between -180 and 180.';
    END IF;
END//

CREATE TRIGGER trg_nws_location_update BEFORE UPDATE ON nws_location
FOR EACH ROW
BEGIN
    IF NEW.LocationID < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LocationID must be a non-negative integer.';
    END IF;
    IF NEW.Latitude <= -90 OR NEW.Latitude > 90 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Latitude must be between -90 and 90.';
    END IF;
    IF NEW.Longitude <= -180 OR NEW.Longitude > 180 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Longitude must be between -180 and 180.';
    END IF;
END//

CREATE TRIGGER trg_nws_location_delete BEFORE DELETE ON nws_location
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM nws_registry_card WHERE LocationID = OLD.LocationID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can\'t remove location, it is connected to nws storages.';
    END IF;
END//

-- nws_registry_card triggers
CREATE TRIGGER trg_nws_registry_card_insert BEFORE INSERT ON nws_registry_card
FOR EACH ROW
BEGIN
    IF NEW.StorageVolume < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'StorageVolume must be a non-negative number.';
    END IF;
    IF NEW.WasteMass < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WasteMass must be a non-negative number.';
    END IF;
    IF NEW.WasteVolume < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WasteVolume must be a non-negative number.';
    END IF;
    IF EXISTS (SELECT 1 FROM nws_registry_card WHERE NWSName = NEW.NWSName) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NWSName already exists in nws_registry_card.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM nws_location WHERE LocationID = NEW.LocationID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LocationID does not exist in nws_location.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM nws_owner_company WHERE CompanyID = NEW.OwnerCompanyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OwnerCompanyID does not exist in nws_owner_company.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM licensed_servicing_agency WHERE AgencyID = NEW.ServicingAgencyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ServicingAgencyID does not exist in licensed_servicing_agency.';
    END IF;
    IF NEW.CertificateID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM storage_certificate WHERE CertificateID = NEW.CertificateID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CertificateID does not exist in storage_certificate.';
    END IF;
END//

CREATE TRIGGER trg_nws_registry_card_update BEFORE UPDATE ON nws_registry_card
FOR EACH ROW
BEGIN
    IF NEW.StorageVolume < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'StorageVolume must be a non-negative number.';
    END IF;
    IF NEW.WasteMass < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WasteMass must be a non-negative number.';
    END IF;
    IF NEW.WasteVolume < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WasteVolume must be a non-negative number.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM nws_location WHERE LocationID = NEW.LocationID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LocationID does not exist in nws_location.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM nws_owner_company WHERE CompanyID = NEW.OwnerCompanyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OwnerCompanyID does not exist in nws_owner_company.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM licensed_servicing_agency WHERE AgencyID = NEW.ServicingAgencyID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ServicingAgencyID does not exist in licensed_servicing_agency.';
    END IF;
    IF NEW.CertificateID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM storage_certificate WHERE CertificateID = NEW.CertificateID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CertificateID does not exist in storage_certificate.';
    END IF;
END//

DELIMITER ;


DROP TRIGGER trg_nws_registry_card_insert;
DROP TRIGGER trg_nws_registry_card_update;

DROP TRIGGER trg_nws_location_insert;
DROP TRIGGER trg_nws_location_update;
DROP TRIGGER trg_nws_location_delete;

DROP TRIGGER trg_nws_owner_company_insert;
DROP TRIGGER trg_nws_owner_company_update;
DROP TRIGGER trg_nws_owner_company_delete;

DROP TRIGGER trg_licensed_servicing_agency_insert;
DROP TRIGGER trg_licensed_servicing_agency_update;
DROP TRIGGER trg_licensed_servicing_agency_delete;

DROP TRIGGER trg_storage_certificate_insert;
DROP TRIGGER trg_storage_certificate_update;
DROP TRIGGER trg_storage_certificate_delete;