@api @files_versions-app-required @skipOnOcV10.10 @skipOnOcV10.11

Feature: file versions remember the author of each version

  Background:
    Given using OCS API version "2"
    And using new DAV path
    And the administrator has set the default folder for received shares to "Shares"
    And auto-accept shares has been disabled
    And user "Alice" has been created with default attributes and without skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And the administrator has enabled the file version storage feature

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users
    Given user "David" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/test"
    And user "Alice" has shared folder "/test" with user "Brian" with permissions "all"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Alice" has shared folder "/test" with user "Carol" with permissions "all"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    And user "Alice" has shared folder "/test" with user "David" with permissions "all"
    And user "David" has accepted share "/test" offered by user "Alice"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/test/textfile0.txt"
    And user "David" has uploaded file with content "uploaded content david" to "/Shares/test/textfile0.txt"
    When user "Alice" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "3"
    And the content of noncurrent version index "1" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content carol"
    And the content of noncurrent version index "2" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "3" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as users "Brian,Carol,David" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users for shared folder in the group
    Given user "Alice" has created folder "/test"
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has shared folder "/test" with group "grp1"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/test/textfile0.txt"
    When user "Alice" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "2"
    And the content of noncurrent version index "1" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "2" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |
    And as users "Brian,Carol" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users for shared file in the group
    Given group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with group "grp1"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Carol" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/textfile0.txt"
    When user "Alice" gets the number of versions of file "textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "2"
    And the content of noncurrent version index "1" of file "/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "2" of file "/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |
    And as users "Brian,Carol" the authors of the noncurrent versions of file "/Shares/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |

  @skip_on_objectstore @skipOnEncryption @issue-encryption-321
  Scenario: enable file versioning and check the history of changes from multiple users while moving file in/out of a subfolder
    Given user "Alice" has created folder "/test"
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has shared folder "/test" with group "grp1"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/test/textfile0.txt"
    And user "Brian" has moved file "/Shares/test/textfile0.txt" to "/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian after moving file outside subfolder" to "/textfile0.txt"
    And user "Brian" has moved file "/textfile0.txt" to "/Shares/test/textfile0.txt"
    When user "Alice" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "3"
    And the content of noncurrent version index "1" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content carol"
    And the content of noncurrent version index "2" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "3" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as users "Brian,Carol" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users after renaming file by sharer
    Given group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/exist.txt"
    And user "Alice" has shared file "/exist.txt" with group "grp1"
    And user "Brian" has accepted share "/exist.txt" offered by user "Alice"
    And user "Carol" has accepted share "/exist.txt" offered by user "Alice"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/exist.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/exist.txt"
    And user "Alice" has moved file "/exist.txt" to "/textfile0.txt"
    When user "Alice" gets the number of versions of file "textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "2"
    And the content of noncurrent version index "1" of file "/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "2" of file "/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as user "Alice" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |
    And as users "Brian,Carol" the authors of the noncurrent versions of file "/Shares/exist.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes in sharer after renaming file by sharee
    Given group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/exist.txt"
    And user "Alice" has shared file "/exist.txt" with group "grp1"
    And user "Brian" has accepted share "/exist.txt" offered by user "Alice"
    And user "Carol" has accepted share "/exist.txt" offered by user "Alice"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/exist.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/exist.txt"
    And user "Brian" has moved file "/Shares/exist.txt" to "/Shares/textfile0.txt"
    When user "Alice" gets the number of versions of file "exist.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "2"
    And the content of noncurrent version index "1" of file "/exist.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "2" of file "/exist.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/exist.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |
    And as users "Carol" the authors of the noncurrent versions of file "/Shares/exist.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |
    And as user "Brian" the authors of the noncurrent versions of file "/Shares/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Alice  |

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users when reshared after unshared by sharer
    Given user "Alice" has created folder "/test"
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has shared folder "/test" with group "grp1"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/test/textfile0.txt"
    And user "Alice" has deleted the last share
    And user "Alice" has uploaded file with content "uploaded content alice after unshared folder" to "/test/textfile0.txt"
    And user "Alice" has shared folder "/test" with group "grp1"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    When user "Alice" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "3"
    And the content of noncurrent version index "1" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content carol"
    And the content of noncurrent version index "2" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "3" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as users "Brian,Carol" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users who have a matching folder/file
    Given user "David" has been created with default attributes and without skeleton files
    And user "Brian" has created folder "/test"
    And user "Brian" has uploaded file with content "duplicate brian" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "overwrite brian" to "/test/textfile0.txt"
    And user "Brian" has shared folder "/test" with user "Carol" with permissions "all"
    And user "Carol" has accepted share "/test" offered by user "Brian"
    And user "Brian" has shared folder "/test" with user "David" with permissions "all"
    And user "David" has accepted share "/test" offered by user "Brian"
    And user "Carol" has created folder "/test"
    And user "Carol" has uploaded file with content "duplicate carol" to "/test/textfile0.txt"
    And user "Carol" has shared folder "/test" with user "Brian" with permissions "all"
    And user "Brian" has accepted share "/test" offered by user "Carol"
    And user "Alice" has created folder "/test"
    And user "Alice" has shared folder "/test" with user "Brian" with permissions "all"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Alice" has shared folder "/test" with user "Carol" with permissions "all"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    And user "Alice" has shared folder "/test" with user "David" with permissions "all"
    And user "David" has accepted share "/test" offered by user "Alice"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test (2)/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/test (2)/textfile0.txt"
    And user "David" has uploaded file with content "uploaded content david" to "/Shares/test (2)/textfile0.txt"
    When user "Alice" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "3"
    And the content of noncurrent version index "1" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content carol"
    And the content of noncurrent version index "2" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "3" of file "/test/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as users "Brian,Carol,David" the authors of the noncurrent versions of file "/Shares/test (2)/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    When user "Brian" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "1"
    And the content of noncurrent version index "1" of file "/test/textfile0.txt" for user "Brian" should be "duplicate brian"
    And as user "Brian" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
    When user "Carol" gets the number of versions of file "/test/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "0"

  @skip_on_objectstore
  Scenario: enable file versioning and check the history of changes from multiple users who have a matching file
    Given user "David" has been created with default attributes and without skeleton files
    And user "Brian" has uploaded file with content "duplicate brian" to "/textfile0.txt"
    And user "Brian" has uploaded file with content "overwrite brian" to "/textfile0.txt"
    And user "Brian" has shared file "/textfile0.txt" with user "Carol"
    And user "Carol" has accepted share "/textfile0.txt" offered by user "Brian"
    And user "Brian" has shared file "/textfile0.txt" with user "David"
    And user "David" has accepted share "/textfile0.txt" offered by user "Brian"
    And user "Carol" has uploaded file with content "duplicate carol" to "/textfile0.txt"
    And user "Carol" has shared file "/textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Carol"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Alice" has shared file "/textfile0.txt" with user "Carol"
    And user "Carol" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Alice" has shared file "/textfile0.txt" with user "David"
    And user "David" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/textfile0 (2).txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/textfile0 (2).txt"
    And user "David" has uploaded file with content "uploaded content david" to "/Shares/textfile0 (2).txt"
    When user "Alice" gets the number of versions of file "/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "3"
    And the content of noncurrent version index "1" of file "/textfile0.txt" for user "Alice" should be "uploaded content carol"
    And the content of noncurrent version index "2" of file "/textfile0.txt" for user "Alice" should be "uploaded content brian"
    And the content of noncurrent version index "3" of file "/textfile0.txt" for user "Alice" should be "uploaded content alice"
    And as users "Alice" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as users "Brian,Carol,David" the authors of the noncurrent versions of file "/Shares/textfile0 (2).txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    When user "Brian" gets the number of versions of file "/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "1"
    And the content of noncurrent version index "1" of file "/textfile0.txt" for user "Brian" should be "duplicate brian"
    And as user "Brian" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
    When user "Carol" gets the number of versions of file "/textfile0.txt"
    Then the HTTP status code should be "207"
    And the number of noncurrent versions should be "0"

  @skip_on_objectstore @files_sharing-app-required
  Scenario: enable file versioning and check the version author after restoring a version of a file inside a folder
    Given user "Alice" has created folder "/test"
    And user "Alice" has shared folder "/test" with user "Brian" with permissions "all"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And user "Alice" has shared folder "/test" with user "Carol" with permissions "all"
    And user "Carol" has accepted share "/test" offered by user "Alice"
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/test/textfile0.txt"
    When user "Brian" restores version index "1" of file "/Shares/test/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as user "Brian,Carol" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |

  @skip_on_objectstore @files_sharing-app-required
  Scenario: enable file versioning and check the version author after restoring a version of a file
    Given user "Alice" has uploaded file with content "uploaded content alice" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Alice" has shared file "/textfile0.txt" with user "Carol"
    And user "Carol" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/textfile0.txt"
    And user "Carol" has uploaded file with content "uploaded content carol" to "/Shares/textfile0.txt"
    When user "Brian" restores version index "1" of file "/Shares/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |
    And as user "Brian,Carol" the authors of the noncurrent versions of file "/Shares/textfile0.txt" should be:
      | index | author |
      | 1     | Carol  |
      | 2     | Brian  |
      | 3     | Alice  |

  @skip_on_objectstore @files_sharing-app-required
  Scenario: check the author of the file version which was created before enabling the version storage
    Given the administrator has disabled the file version storage feature
    And user "Alice" has uploaded file with content "uploaded content alice" to "/textfile0.txt"
    And user "Alice" has shared folder "/textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And the administrator has enabled the file version storage feature
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/textfile0.txt"
    When user "Brian" restores version index "1" of file "/Shares/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     |        |
    And as user "Brian" the authors of the noncurrent versions of file "/Shares/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     |        |
    When user "Brian" restores version index "1" of file "/Shares/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the authors of the noncurrent versions of file "/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Brian  |
      | 3     |        |
    And as user "Brian" the authors of the noncurrent versions of file "/Shares/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Brian  |
      | 3     |        |

  @skip_on_objectstore @files_sharing-app-required
  Scenario: check the author of the file version (inside a folder) which was created before enabling the version storage
    Given user "Alice" has created folder "/test"
    And the administrator has disabled the file version storage feature
    And user "Alice" has uploaded file with content "uploaded content alice" to "/test/textfile0.txt"
    And user "Alice" has shared folder "/test" with user "Brian" with permissions "all"
    And user "Brian" has accepted share "/test" offered by user "Alice"
    And the administrator has enabled the file version storage feature
    And user "Brian" has uploaded file with content "uploaded content brian" to "/Shares/test/textfile0.txt"
    When user "Brian" restores version index "1" of file "/Shares/test/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     |        |
    And as user "Brian" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     |        |
    When user "Brian" restores version index "1" of file "/Shares/test/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the authors of the noncurrent versions of file "/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Brian  |
      | 3     |        |
    And as user "Brian" the authors of the noncurrent versions of file "/Shares/test/textfile0.txt" should be:
      | index | author |
      | 1     | Brian  |
      | 2     | Brian  |
      | 3     |        |
