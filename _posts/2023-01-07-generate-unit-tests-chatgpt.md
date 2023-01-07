---
layout: post
title: Generate BATS Unit Tests with ChatGPT
date: 2023-01-07 14:27:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - chatgpt
  - "unit tests"
  - bash
tags:
  - chatgpt
  - "unit tests"
  - bash
  - bats
---
Of course everyone has now heard about [ChatGPT](https://openai.com/blog/chatgpt/). I've seen a few posts on [LinkedIn](https://www.linkedin.com) where people have used it to generate code. I thought I'd have a quick go at seeing if ChatGPT would generate useful units tests. So I gave it the following bash function...

```bash
mytest () {
        var="$1";
        if [[ "$var" == "rhys" ]]; then
                echo "Hello Rhys"
        else
                echo "Hello $var"
        fi;
}
```

and I asked it... 

> Hello, Can you write me some test cases for this Bash function?

```
Sure! Here are some test cases for the Bash function:

    Test that the function correctly prints "Hello Rhys" when given "rhys" as an input:

test "rhys"

Expected output:

Hello Rhys

    Test that the function correctly prints "Hello [name]" when given a name other than "rhys" as an input:

test "John"

Expected output:

Hello John

    Test that the function correctly handles an empty input:

test ""

Expected output:

Hello

    Test that the function correctly handles inputs with spaces:

test "John Smith"

Expected output:

Hello John Smith

    Test that the function correctly handles inputs with special characters:

test "!@#$%^&*()"

Expected output:

Hello !@#$%^&*()
````

OK, pretty good but let's try something a little more practical. I like using the [BATS Unit Testing Framework](https://github.com/sstephenson/bats) for bash. So I asked it to generate the tests again using BATS...

> Can you write the same test cases using the BATS framework?

```
Sure! Here are the test cases written using the BATS (Bash Automated Testing System) framework:
```

```bash
# Test that the function correctly prints "Hello Rhys" when given "rhys" as an input
@test "mytest prints 'Hello Rhys' when given 'rhys' as an input" {
  run mytest "rhys"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Rhys" ]
}

# Test that the function correctly prints "Hello [name]" when given a name other than "rhys" as an input
@test "mytest prints 'Hello [name]' when given a name other than 'rhys' as an input" {
  run mytest "John"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello John" ]
}

# Test that the function correctly handles an empty input
@test "mytest handles an empty input" {
  run mytest ""
  [ "$status" -eq 0 ]
  [ "$output" = "Hello" ]
}

# Test that the function correctly handles inputs with spaces
@test "mytest handles inputs with spaces" {
  run mytest "John Smith"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello John Smith" ]
}

# Test that the function correctly handles inputs with special characters
@test "mytest handles inputs with special characters" {
  run mytest "!@#$%^&*()"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello !@#$%^&*()" ]
}
```

Here's the output when I run those tests...

```
 ✓ mytest prints 'Hello Rhys' when given 'rhys' as an input 
 ✓ mytest prints 'Hello [name]' when given a name other than 'rhys' as an input 
 ✗ mytest handles an empty input
   (in test file tests.bats, line 20)
     `[ "$output" = "Hello" ]' failed
 ✓ mytest handles inputs with spaces 
 ✓ mytest handles inputs with special characters 

5 tests, 1 failure
```

One test is failing because it doesn't account for the fact that whitespace will be returned in the output when an empty input is provided. Let's ask ChatGPT to correct this...

> In the test labelled "mytest handles an empty input" you don't take account of that fact that whitespace will be returned in the output. Therefore the test will always fail. Can you correct this please?"

It provided the following code...

```bash
# Test that the function correctly handles an empty input
@test "mytest handles an empty input" {
  run mytest ""
  [ "$status" -eq 0 ]
  [ "$output" = "Hello " ]
}
```

Now all the tests run correctly...

```
 ✓ mytest prints 'Hello Rhys' when given 'rhys' as an input 
 ✓ mytest prints 'Hello [name]' when given a name other than 'rhys' as an input 
 ✓ mytest handles an empty input 
 ✓ mytest handles inputs with spaces 
 ✓ mytest handles inputs with special characters 

5 tests, 0 failures
```

Now I am not surprised that ChatGPT made a mistake with the whitespace but, I am pretty impressed it could fix it, once I pointed out that mistake!

What else have I asked ChatGPT?

- Hi ChatGPT, can you generate me an Ansible Playbook to install MariaDB on a CentOS system with some common settings changed?
- Can you do the same thing but for a Debian based system?
- Can you generate a testinfa class to validate a MariaDB server is running and the root login is secured?
- Can you also generate a test that will check the MariaDB server is listening on 3306?

It gave pretty good answers for all of these, although probably not 100% production ready, it certainly provided a good starting point and takes out some of the tediousness of some of these tasks!