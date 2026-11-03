import pytest

pytest.importorskip("numpy")
pytest.importorskip("scipy")
pytest.importorskip("torch")
pytest.importorskip("uproot")
pytest.importorskip("uproot3")
pytest.importorskip("uproot4")

from ndgeoeff.step2_muon.make_tree_nd import isContained, isFV


def test_fiducial_volume_accepts_center():
    assert isFV(0.0, 0.0, 200.0)


def test_fiducial_volume_rejects_outside():
    assert not isFV(400.0, 0.0, 200.0)
    assert not isFV(0.0, 0.0, 400.0)


def test_containment():
    assert isContained(0.0, 0.0, 200.0)
    assert not isContained(400.0, 0.0, 200.0)
