from app.normalizer import make_patient_id


def test_make_patient_id_uses_safe_uuid_prefix():
    assert make_patient_id("a1b2c3d4-1111-2222-3333-444455556666") == "patient-a1b2c3d4"
