#!/usr/bin/python
import re
with open('build.gradle', 'r') as f:
    print(re.sub('task\s+prepareKotlinBuildScriptModel\s+\{\s+\}', '', f.read()))