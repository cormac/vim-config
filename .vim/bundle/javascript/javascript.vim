setlocal makeprg=jslint\ %
setlocal errorformat=%-P%f,
         \%-G/*jslint\ %.%#*/,
         \%*[\ ]%n\ %l\\,%c:\ %m,
         \%-G\ \ \ \ %.%#,
         \%-GNo\ errors\ found.,
         \%-Q
