﻿Import-Module ActiveDirectory
Move-ADDirectoryServerOperationMasterRole -Identity "DC01" -OperationMasterRole PDCEmulator