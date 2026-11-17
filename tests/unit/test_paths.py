from app import paths


def test_repository_layout_exists():
    assert paths.REPO_ROOT.is_dir()
    assert (paths.REPO_ROOT / "app").is_dir()
    assert (paths.REPO_ROOT / "include").is_dir()
    assert (paths.REPO_ROOT / "src").is_dir()
    assert paths.STEP3_DATA_DIR.is_dir()
    assert paths.MACROS_DIR.is_dir()
