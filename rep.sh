mkdir -p /var/www/altlinux/p10/
rsync -avh --progress --delete \
  --include="x86_64/*** " --include="noarch/*** " \
  --exclude="*" \
  rsync://ftp.altlinux.org/ALT/p10/ /var/www/altlinux/p10/
