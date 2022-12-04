# HistoryRules

__[Experimental feature, may or may not function correctly or remain part of CL3 in future releases]__

HistoryRules determines which content will be added to the CL3 Clipboard History based on Regular Expressions.  

In order to activate HistoryRules, an `INI file` has to be manually created (example below).

* Mandatory file name: `HistoryRules.ini`
* Location: main CL3 folder e.g. where `CL3.ahk` and `settings.ini` also reside

Note that after each edit of `HistoryRules.ini`, CL3 has to be restarted manually.

## Sections

There is one global `setting` section. Each rule needs a section.

### Global section

```ini
[setting]
global=1
copy=1
```

*keys* 

global: `0` (disable); or `1` (enable) HistoryRules  
copy: `0` do not copy to clipboard; or `1` copy to clipboard but do not include in Clipboard History (so you can still paste the copied text - an asterisk will be added to the first entry in the Clipboard History menu as indicator. Same behaviour as "[Excluded programs](https://github.com/hi5/CL3/blob/master/changelog.md#v199)"

### Rule() section(s)

Section names can be anything and don't have a meaning (yet).

There can be multiple rules which may conflict. If _a_ rule will not allow content to be added, subsequent rules will not change this outcome.

```ini
[Name of Rule1]
active=1
filter=i)www
```
*keys* 

active: `0` (disable) or `1` (enable)  
filter: regular expression to match to allow contents to be added or ignored.

## Complete Example

```ini
[setting]
global=1
copy=1
[Name of Rule1]
active=0
filter=i)www
[Name of Rule2]
active=1
filter=imU)^((?!http|www).)*$
```

Meaning:

* _Name of Rule1_: only add entries to the Clipboard History that contain `www`
* _Name of Rule2_: exclude entries to the Clipboard History that contain `www` or `http` (e.g. urls)
