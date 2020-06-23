# Components and utility classes

Table of contents

- [Button](#button)
- [Callout](#callout)
- [Collapse](#collapse)
- [Dropdown](#dropdown)
- [Headings](#headings)
- [Input](#input)
- [Link](#link)
- [Lists](#lists)
- [Section gutter](#section-gutter)
- [Section padding](#section-padding)
- [Select](#select)
- [Toggler](#toggler)

## Button

The button component is not exclusive to the `<button>` element, it can be used on `<a>` elements as well. We have a default button class which we can combine with other classes for different types of buttons.

- `button` is our default button class and perfectly fine to use on its own. If you need a regular button, this is your friend. It is the base of all other types of buttons.
- `button-inverted` is a light version of the default button, meaning it's white outlines with white text. This button should be used on dark backgrounds. It has to be used in combination with the default button class to work properly.
- `button-cta` is a button that calls for the user's attention. This is used when we want the user to take an action, such as to log in, to sign up or to get started. It has to be used in combination with the default button class to work properly.

### Examples

Default buttons

```
<button type="button" class="button">I am a regular button</button>
<a href="#" class="button">I am too a regular button</a>
```

Combination buttons

```
<button type="button" class="button button-inverted">I am an inverted button</button>
<a href="#" class="button button-cta">Give me attention!</a>
```

## Callout

A simple box that has the purpose to highlight important information or interaction. I should have some sort of size limitation, whether if it's max width or controlled by a parent element - it should not be used as a fullscreen element. It should not be used on the same element as `section-gutter` or `section-padding`. 

### Examples

```
<div class="callout max-w-lg mx-auto">
  I am inside a callout. I am important!
</div>
```

## Collapse

This is component that on toggle collapses or expands a content box - all just HTML and CSS. It is however important to keep the markup correct for it to function properly.

### Examples

Basic usage

```
<div class="collapse">
  <input id="some-sort-of-element-id" type="checkbox">
  <label for="some-sort-of-element-id" class="cursor-pointer">
    Click me to toggle the content!
  </label>
  <div class="collapse-content pt-4">
    <p>I am the content that will be revealed or hidden.</p>
  </div>
</div>
```

Usage with animated chevron. Notice the class `collapse-chevron`.

```
<div class="collapse">
  <input id="some-sort-of-element-id" type="checkbox">
  <label for="some-sort-of-element-id" class="flex justify-between cursor-pointer">
    <p>Click me to toggle the content!</p>
    <div class="pl-3">
      <i class="fa fa-chevron-circle-down collapse-chevron" aria-hidden="true"></i>
    </div>
  </label>
  <div class="collapse-content pt-4">
    <p>I am the content that will be revealed or hidden.</p>
  </div>
</div>
```

## Dropdown

This is an HTML and CSS component that is a toggleable dropdown menu. By default the menu places itself below the trigger element and is left aligned, it can however be placed above and/or right aligned. 

### Examples

Default use case

```
<div class="dropdown"> 
  <input id="some-sort-of-element-id" type="checkbox" class="dropdown-toggler">
  <label for="some-sort-of-element-id" class="button" aria-haspopup="true" aria-expanded="false">
    Click me to open dropdown
  </label> 
  <ul class="dropdown-menu" aria-labelledby="some-sort-of-element-id"> 
    <li>Item 1</li>
    <li>Item 2</li>
    <li>Item 3</li>
  </ul> 
</div>
```

Dropdown menu, right aligned. Notice the additional class on the `dropdown-menu` element.

```
<div class="dropdown"> 
  <input id="some-sort-of-element-id" type="checkbox" class="dropdown-toggler">
  <label for="some-sort-of-element-id" class="button" aria-haspopup="true" aria-expanded="false">
    Click me to open dropdown
  </label> 
  <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="some-sort-of-element-id"> 
    <li>Item 1</li>
    <li>Item 2</li>
    <li>Item 3</li>
  </ul> 
</div>
```

Dropup menu, the menu is positioned above the trigger. Notice the additional class on the `dropdown-menu` element.

```
<div class="dropdown"> 
  <input id="some-sort-of-element-id" type="checkbox" class="dropdown-toggler">
  <label for="some-sort-of-element-id" class="button" aria-haspopup="true" aria-expanded="false">
    Click me to open dropdown
  </label> 
  <ul class="dropdown-menu dropdown-menu-up" aria-labelledby="some-sort-of-element-id"> 
    <li>Item 1</li>
    <li>Item 2</li>
    <li>Item 3</li>
  </ul> 
</div>
```

## Headings

These are helper classes to keep our headings consitent and responsive. The font size and font weight is handled, not the margin or padding.

- `heading` is quite similar to body text in size and is typically used to accentuate smaller things that is not a page header or section header.
- `heading-lg` is typically used in sections of a page. 
- `heading-xl` is to be used as the headline of a page and should generally only be used once. Usually it's used on an `<h1>` element.

### Examples

A typical use case for the different classes.

```
<h1 class="heading-xl">
  Welcome to a very cool page
</h1>

<h2 class="heading-lg">
  Let me describe this section for you
</h2>

<h3 class="heading">
  Here is a regular heading, headlining a paragraph
</h3>
```

## Input

Styling of the native HTML element.

### Examples

Basic usage.

```
<input type="text" class="input">
```

Usage with rails form helper class.

```
<%= my_form.email_field :email, required: true, id: "email", class: "input" %>
```

## Link

Styling of the native HTML element. There are multiple link classes for different use cases. 

- `link` is to be used within in running text, usually in a `<p>`
- `link-icon` TBA
- `link-ui` is to be used when it's not in a running text but rather as an UI element, for instance in a navigation bar.

### Examples

```
<p>
  I am a text that is a little longer and I also contain a very cool <a href="#" class="link">link</a>, how about that, huh?
</p>
```

UI link use case.

```
<ul>
  <li><a href="#" class="link-ui">Navigation link 1</a></li>
  <li><a href="#" class="link-ui">Navigation link 2</a></li>
  <li><a href="#" class="link-ui">Navigation link 3</a></li>
</ul>
```

## Lists

By our default CSS normalization and Tailwind preflight, `<ul>` and `<ol>` are unstyled. These are some components that styles `<ul>` or `<ol>` into lists that can be used in running text.  

### Examples

```
<ul class="list-bullet">
  <li>I have a point</li>
  <li>I too, have a point in this list</li>
  <li>What is the point?</li>
</ul>
```

## Section gutter

Section gutter is to be used together with `section padding`, and makes sure there is gutter space between the items.

### Examples

```
<section class="section-padding">
  <div class="section-gutter">
    <div>
      I have some content.
    </div>
    <div>
      I have some other content.
    </div>
  </div>
</section>
```

## Section padding

When creating a regular page that has sections, this class comes in handy to keep the padding consistent and responsive. When having multiple columns, use in combination with `section gutter`.

### Examples

```
<section class="section-padding">
  I have some content that will have appropriate padding on different breakpoints.
</section>
```

## Select

Styling of the native HTML element. As it's not possible to use psuedo selectors on the `select` element, the markup requires a wrapper, which takes care of styling the chevron. It is possible to use without the wrapper, but the styling of the chevron then falls back to browser default as a way of alerting you of incorrect markup.

### Examples

Basic usage

```
<div class="select-wrapper">
  <select class="select">
    <option value="economy">Economy</option>
    <option value="premium_economy">Premium Economy</option>
    <option value="business">Business</option>
    <option value="first">First</option>
  </select>
</div>
```

Controlling the width is done on the wrapper element.

```
<div class="select-wrapper w-full">
  <select class="select">
    <option value="economy">Economy</option>
    <option value="premium_economy">Premium Economy</option>
    <option value="business">Business</option>
    <option value="first">First</option>
  </select>
</div>
```

## Toggler

Toggler is a set of helper classes that makes it possible to control elements on toggle, all with HTML and CSS. The markup takes advantage of input checkbox and CSS sibling selectors. It is important to keep the markup correct in order to achieve the desired functionality.

- `toggler` should be placed on the checkbox being used as the toggle.
- `toggler-checked` is a prefix to be used with utility classes. In practice it works like breakpoints, so that when the toggler is checked, the utility class is applied. The following classes work:
  - `toggler-checked:h-screen`
  - `toggler-checked:scale-y-100`
  - `toggler-checked:opacity-100`

### Examples

```
<input type="checkbox" id="my-toggler-id" class="toggler">
<div class="opacity-0 toggler-checked:opacity-100">
  I am invisible until the toggler is checked!
</div>

<label for="my-toggler-id">
  Click me to toggle!
</label>
```
