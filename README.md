# vimeo_3
Vimeo API v3 GEM

Add it to your Gemfile (The gem uses semantic versioning):

    gem 'vimeo_3', '~0.0.1'

Use it:

    upload = Vimeo3.new('id', 'secret', {:accessToken => 'token'}).getForm('http://test.me/')



To upload videos, just pass you form url to the getForm function and use the returned secure URL at your form:

    upload["upload_link_secure"]
