 slug(String inputString) {
  return inputString.replaceAll('"', '');
}
 String slugify(String input) {
   Map<String, String> charMap = {
     'İ': 'i',
     'ı': 'i',
     'ş': 's',
     'Ş': 's',
     'ç': 'c',
     'Ç': 'c',
     'ü': 'u',
     'Ü': 'u',
     'ö': 'o',
     'Ö': 'o',
     'ğ': 'g',
     'Ğ': 'g'
   };

   String slug = input.split('').map((char) {
     return charMap[char] ?? char;
   }).join('');

   slug = slug.toLowerCase();

   slug = slug
       .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
       .replaceAll(RegExp(r'-+'), '-')
       .trim();

   slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');

   return slug;
 }