---
layout: post
title:  "Wordpress to GitHub Pages Migration"
date:   2021-03-14 13:23:00 +0100
categories:
  - "jekyll"
  - "gihub pages"
---
I've just completed the migration of a Wordpress blog to GitHub pages using the Ruby based [Jekyll](https://jekyllrb.com/) blogging engine. The following resource was very useful...

[Migrating from Wordpress to GitHub Pages](https://guillermo-roman.com/migrating-wordpress-blog-to-github-pages/)

But there were a couple of small changes I need to make to get this fully working for me. The code to convert the Wordpress xml export the markdown format contains a minor error...

{% highlight ruby %}
ruby -rubygems -e 'require "jekyll-import";
JekyllImport::Importers::WordpressDotCom.run({
  "source" => "youdidwhatwithtsqlcom.wordpress.2021-03-13.xml",
  "no_fetch_images" => false,
  "assets_folder" => "assets/images"
})'
{% endhighlight %}

This threw the following error:

> Traceback (most recent call last):
	1: from /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- ubygems (LoadError)

This command should be:

{% highlight ruby %}
ruby -r rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::WordpressDotCom.run({
      "source" => "youdidwhatwithtsqlcom.wordpress.2021-03-13.xml",
      "no_fetch_images" => false,
      "assets_folder" => "assets"
    })'
{% endhighlight %}

After this I could convert all my posts to html format. Then I could run the `ruby ./wordpress-html-to-md.rb "_posts"` command to convert all of the posts to markdown. This worked but I spotted a formatting problem. All of my code snippets were on a single line. Something was stripping all the line endings from my code examples. I tracked this down to the reverse_markdown (2.0.0) library used by the conversion process. This problem has already [been fixed](https://github.com/shivabhusal/reverse_markdown/commit/63b5019ffad14a0875a3ece58e10d38c5881597b) with the addition of three lines of code. This wasn't availabe to me via gem install so I just pasted the following lines of code:

{% highlight ruby %}
when 'text'
  # Preserve '\n' in the middle of text/words, get rid of indentation spaces
  ReverseMarkdown.cleaner.remove_leading_newlines(node.text.gsub("\n", '<br>').strip.gsub('<br>', "\n"))
{% endhighlight %}

into the following file ***/Library/Ruby/Gems/2.6.0/gems/reverse_markdown-2.0.0/lib/reverse_markdown/converters/pre.rb***. Rerunning the conversion process showed the problem had been resolved.
