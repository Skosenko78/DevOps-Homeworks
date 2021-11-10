# **2.4. Инструменты Git**

# *1. Найдите полный хеш и комментарий коммита, хеш которого начинается на 'aefea'.*
Полный хэш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Комментарий: Update CHANGELOG.md
   
Данные получены из вывода команды: 
```
git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

diff --git a/CHANGELOG.md b/CHANGELOG.md
index 86d70e3e0..588d807b1 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -27,6 +27,7 @@ BUG FIXES:
 * backend/s3: Prefer AWS shared configuration over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
 * backend/s3: Prefer ECS credentials over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
 * backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://github.com/hashicorp/terraform/issues/25134))
+* command: Fix bug with global `-v`/`-version`/`--version` flags introduced in 0.13.0beta2 [GH-25277]
 * command/0.13upgrade: Fix `0.13upgrade` usage help text to include options ([#25127](https://github.com/hashicorp/terraform/issues/25127))
 * command/0.13upgrade: Do not add source for builtin provider ([#25215](https://github.com/hashicorp/terraform/issues/25215))
 * command/apply: Fix bug which caused Terraform to silently exit on Windows when using absolute plan path ([#25233](https://github.com/hashicorp/terraform/issues/25233))
```

# *2. Какому тегу соответствует коммит '85024d3'?*
Коммит соответсвует тегу 'tag: v0.12.23'

Данные получены из вывода команды:
```
git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23

diff --git a/CHANGELOG.md b/CHANGELOG.md
index 1a9dcd0f9..faedc8bf4 100644
...
```
Так же тег можно увидеть в выводе данной команды:
```
git log --oneline -1 85024d3
85024d310 (tag: v0.12.23) v0.12.23
```

# *3. Сколько родителей у коммита b8d720? Напишите их хеши.*
У коммита 'b8d720' 2 родителя:
```
Хеш 1: 56cd7859e05c36c06b56d013b55a252d0bb7e158
Хеш 2: 9ea88f22fc6269854151c571162c5bcf958bee2b
```

Данные получены из вывода команды:
```
git log --graph b8d720
*   commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
|\  Merge: 56cd7859e 9ea88f22f
| | Author: Chris Griggs <cgriggs@hashicorp.com>
| | Date:   Tue Jan 21 17:45:48 2020 -0800
| | 
| |     Merge pull request #23916 from hashicorp/cgriggs01-stable
| |     
| |     [Cherrypick] community links
| | 
| * commit 9ea88f22fc6269854151c571162c5bcf958bee2b
|/  Author: Chris Griggs <cgriggs@hashicorp.com>
|   Date:   Tue Jan 21 17:08:06 2020 -0800
|   
|       add/update community provider listings
|   
*   commit 56cd7859e05c36c06b56d013b55a252d0bb7e158
|\  Merge: 58dcac4b7 ffbcf5581
| | Author: Chris Griggs <cgriggs@hashicorp.com>
| | Date:   Mon Jan 13 13:19:09 2020 -0800
| | 
| |     Merge pull request #23857 from hashicorp/cgriggs01-stable
...
```
# *4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.*
```
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
```

Данные получены командой:
```
git log --oneline v0.12.23..v0.12.24
```

# *5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).*
Коммит в котором была создана функция: 8c928e83589d90a031f811fae52a81be7153e82f

Информация получена командой:
```
git log --pretty=short -S 'func providerSource('
commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>

    main: Consult local directories as potential mirrors of providers
```

# *6. Найдите все коммиты в которых была изменена функция globalPluginDirs.*
Сначала найдём файлы, в которых описывается данная функция:
```
git grep 'func globalPluginDirs'
plugins.go:func globalPluginDirs() []string {
```
Теперь найдём коммиты, в которых были изменения тела функции. Для этого используем команду:
```
git log -L :globalPluginDirs:plugins.go
commit 78b12205587fe839f10d946ea3fdc06719decb05
Author: Pam Selle <204372+pselle@users.noreply.github.com>
Date:   Mon Jan 13 16:50:05 2020 -0500

    Remove config.go and update things using its aliases

diff --git a/plugins.go b/plugins.go
--- a/plugins.go
+++ b/plugins.go
@@ -16,14 +18,14 @@
 func globalPluginDirs() []string {
        var ret []string
        // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
...
```
В листинге находим коммиты:
```
    commit 78b12205587fe839f10d946ea3fdc06719decb05
    commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46
    commit 41ab0aef7a0fe030e84018973a64135b11abcd70
    commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17
    commit 8364383c359a6b738a436d1b7745ccdce178df47
```

# *7. Кто автор функции synchronizedWriters?*
Не смог найти упоминание функции 'synchronizedWriters'. Использовал команду:
```
git grep -p 'synchronizedWriters'
```