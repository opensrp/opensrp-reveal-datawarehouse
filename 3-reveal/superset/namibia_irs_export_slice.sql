SELECT
    DISTINCT(structure_id),
    structure_jurisdiction_id,
    structure_code,
    structure_name,
    structure_type,
    structure_status,
    task_id,
    event_id,
    plan_id,
    event_date,
    nSprayableTotal,
    nSprayableZinc,
    nSprayableTrad,
    nSprayableMod,
    nSprayableCanopy,
    nUnsprayable,
    nSprayedTotalFirst,
    nSprayedTotalMop,
    nUnsprayedTotalFirst,
    nUnsprayedTotalMop,
    householdAccessible,
    unsprayedReasonFirst,
    unsprayedReasonMop,
    refusalReasonFirst,
    refusalReasonMop,
    business_status,
    ableToSprayFirst,
    nSprayedDDTFirst,
    nSprayedDeltaFirst,
    nSprayedActellicFirst,
    nUnsprayedZincFirst,
    nUnsprayedTradFirst,
    nUnsprayedModFirst,
    nUnsprayedCanopyFirst,
    refusalReasonOtherFirst,
    mopUpVisit,
    mopupStructuresToBeSprayed,
    mopupStructuresToBeSprayedLabel,
    nSprayedDDTMop,
    nSprayedDeltaMop,
    nSprayedActellicMop,
    nUnsprayedTotalMopLabel,
    refusalReasonOtherMop,
    unsprayedReasonHH,
    refusalReasonHH,
    refusalReasonOtherHH,
    popTotal,
    nPeopleProtected,
    nameHoH,
    structureType,
    unsprayedReasonFirst_values,
    refusalReasonFirst_values,
    unsprayedReasonMop_values,
    refusalReasonMop_values,
    structure_geometry_type,
    structure_geometry_centroid_coordinates,
    jurisdiction_parent1,
    jurisdiction_parent2,
    jurisdiction_parent3,
    jurisdiction_name
FROM namibia_irs_export;