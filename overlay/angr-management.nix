[
  # angr-management: init at 9.2.130 (#360310)
  (final: prev: {
    angr-management = final.python3Packages.buildPythonApplication rec {
      pname = "angr-management";
      version = final.python3Packages.angr.version;
      pyproject = true;

      src = final.fetchFromGitHub {
        owner = "angr";
        repo = "angr-management";
        tag = "v${version}";
        hash = "sha256-ZaQRXCt6u5FGApiXTToJdIXBnBLv3emo13YG5ip0lJA=";
      };

      pythonRelaxDeps = [ "binsync" ];

      build-system = with final.python3Packages; [ setuptools ];

      dependencies =
        with final.python3Packages;
        (
          [
            # requirements from setup.cfg
            angr
            bidict
            binsync
            ipython
            pyqodeng-angr
            pyside6
            pyside6-qtads
            qtawesome
            qtpy
            requests
            rpyc
            thefuzz
            tomlkit
            # requirements from setup.cfg -- vendorized qtconsole package
            ipykernel
            jupyter-client
            jupyter-core
            packaging
            pygments
            pyzmq
            traitlets
          ]
          ++ angr.optional-dependencies.angrdb
          ++ requests.optional-dependencies.socks
          ++ thefuzz.optional-dependencies.speedup
        );

      pythonImportsCheck = [ "angrmanagement" ];

      meta = {
        description = "The official angr GUI";
        homepage = "https://github.com/angr/angr-management";
        changelog = "https://github.com/angr/angr-management/releases/tag/${src.tag}";
        license = final.lib.licenses.bsd2;
        maintainers = with final.lib.maintainers; [ scoder12 ];
        mainProgram = "angr-management";
      };
    };

    pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
      (pyfinal: pyprev: {
        binsync = pyfinal.buildPythonPackage rec {
          pname = "binsync";
          version = "5.3.0";
          pyproject = true;

          src = final.fetchFromGitHub {
            owner = "binsync";
            repo = "binsync";
            tag = "v${version}";
            hash = "sha256-f0pPuNTrZ5+iuJgtxLXJF89C9hKXwplhBA/olyhfsQ4=";
          };

          build-system = with pyfinal; [ setuptools ];

          dependencies = with pyfinal; [
            filelock
            gitpython
            libbs
            prompt-toolkit
            pycparser
            sortedcontainers
            toml
            tqdm
          ];

          optional-dependencies = {
            ghidra = with pyfinal; [ pyside6 ];
          };

          nativeCheckInputs = with pyfinal; [
            pyside6
            pytest-qt
            pytestCheckHook
          ];

          disabledTestPaths = [
            # Test tries to import angrmanagement
            "tests/test_angr_gui.py"
          ];

          pythonImportsCheck = [ "binsync" ];

          meta = {
            description = "A reversing plugin for cross-decompiler collaboration, built on git";
            homepage = "https://github.com/binsync/binsync";
            changelog = "https://github.com/binsync/binsync/releases/tag/v${version}";
            license = final.lib.licenses.bsd2;
            maintainers = with final.lib.maintainers; [ scoder12 ];
          };
        };

        pyqodeng-angr = pyfinal.buildPythonPackage rec {
          pname = "pyqodeng-angr";
          version = "0.0.13";
          pyproject = true;

          src = final.fetchFromGitHub {
            owner = "angr";
            repo = "pyqodeng";
            tag = "v${version}";
            hash = "sha256-t4LcPVQfktAaTqTr9L2VDCEHbSO7qxCvUDz6rj0Zre4=";
          };

          patches = [
            (final.fetchpatch2 {
              name = "0001-drop-python-2.patch";
              url = "https://github.com/angr/pyqodeng/commit/45bc2b39f2cccd4a00bfeb4809328ef566b38d08.patch?full_index=1";
              hash = "sha256-ZdYm+q4mhAkdz0mo5rW3YhdbPwcVH44guMgMJuVHGhI=";
            })
          ];

          postPatch = ''
            substituteInPlace setup.py \
              --replace-quiet 'PySide6-Essentials' 'PySide6'
          '';

          build-system = with pyfinal; [ setuptools ];

          dependencies = with pyfinal; [
            pygments
            qtpy
            pyside6
          ];

          # Tests appear to be broken with pyside6
          doCheck = false;

          nativeCheckInputs = with pyfinal; [
            pytest-xdist
            pytestCheckHook
            pyside6
          ];

          pythonImportsCheck = [ "pyqodeng" ];

          meta = {
            description = "Angr's fork of pyQode.core, used as part of angr management";
            homepage = "https://github.com/angr/pyqodeng";
            changelog = "https://github.com/angr/pyqodeng/blob/${src.rev}/CHANGELOG.rst";
            license = final.lib.licenses.mit;
            maintainers = with final.lib.maintainers; [ scoder12 ];
          };
        };
      })
    ];
  })
]
