from ndgeoeff.common import paths


def test_repository_layout_exists():
    assert paths.REPO_ROOT.is_dir()
    assert (paths.REPO_ROOT / "apps" / "step1_hadron_geoeff").is_dir()
    assert (paths.REPO_ROOT / "apps" / "step3_etrim_analysis").is_dir()
    assert (paths.REPO_ROOT / "python" / "ndgeoeff" / "step2_muon").is_dir()
    assert paths.STEP3_DATA_DIR.is_dir()
    assert paths.MACROS_DIR.is_dir()
