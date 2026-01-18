# Code Style: Good vs Bad Examples

This document provides before/after examples of common style issues.

## Example 1: Indentation

### Bad
```javascript
function example(){
if(condition){
doSomething();
}
}
```

### Good
```javascript
function example() {
  if (condition) {
    doSomething();
  }
}
```

**Why**: Consistent 2-space indentation improves readability.

---

## Example 2: Line Length

### Bad
```javascript
const errorMessage = "This is a very long error message that extends far beyond the recommended line length and becomes difficult to read, especially in split-screen views or code reviews";
```

### Good
```javascript
const errorMessage =
  "This is a long error message that has been split " +
  "across multiple lines for better readability " +
  "in code reviews and split-screen views";
```

**Why**: Lines under 100 characters are easier to read and work better in side-by-side diffs.

---

## Example 3: Naming Conventions

### Bad
```javascript
let UserName = "John";  // PascalCase for variable
const api_base_url = "https://api.com";  // snake_case for constant
function GetUserData() { }  // PascalCase for function

class user_account { }  // snake_case for class
```

### Good
```javascript
let userName = "John";  // camelCase for variable
const API_BASE_URL = "https://api.com";  // UPPER_SNAKE_CASE for constant
function getUserData() { }  // camelCase for function

class UserAccount { }  // PascalCase for class
```

**Why**: Consistent naming conventions make code predictable and easier to navigate.

---

## Example 4: Comments

### Bad
```javascript
// This function gets the user
function getUser() {
  // Get the id
  const id = getCurrentUserId();
  // Fetch from API
  return fetchUser(id);
}

// const oldCode = "commented out";
// function unusedFunction() { }
```

### Good
```javascript
/**
 * Retrieves user data for the currently authenticated user
 * @returns {Promise<User>} User object with profile data
 */
function getUser() {
  const id = getCurrentUserId();
  // Using cached endpoint for better performance - see issue #123
  return fetchUser(id);
}
```

**Why**: Good comments explain *why*, not *what*. Remove commented-out code (use git history).

---

## Example 5: Spacing and Braces

### Bad
```javascript
if(x===y)
{
return x+y;
}
else return z;
```

### Good
```javascript
if (x === y) {
  return x + y;
} else {
  return z;
}
```

**Why**: Consistent spacing and brace placement improves scannability.

---

## Example 6: Imports

### Bad
```javascript
import './styles.css';
import { utils } from './utils';
import axios from 'axios';
import React from 'react';
import { Component } from './components';
```

### Good
```javascript
// External dependencies
import React from 'react';
import axios from 'axios';

// Internal dependencies
import { Component } from './components';
import { utils } from './utils';

// Styles
import './styles.css';
```

**Why**: Grouped and sorted imports are easier to navigate and reduce merge conflicts.

---

## Example 7: Error Handling

### Bad
```javascript
async function fetchUserData(userId) {
  const response = await fetch(`/api/users/${userId}`);
  const data = await response.json();
  return data;
}
```

### Good
```javascript
async function fetchUserData(userId) {
  try {
    const response = await fetch(`/api/users/${userId}`);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    logger.error('Failed to fetch user data:', { userId, error });
    throw new UserDataError(`Unable to fetch data for user ${userId}`);
  }
}
```

**Why**: Explicit error handling prevents silent failures and aids debugging.

---

## Example 8: Modern Syntax

### Bad
```javascript
var name = user.name;
var email = user.email;

var numbers = [1, 2, 3];
var moreNumbers = numbers.concat([4, 5]);

fetchData().then(function(result) {
  return processResult(result);
}).then(function(processed) {
  console.log(processed);
}).catch(function(error) {
  console.error(error);
});
```

### Good
```javascript
const { name, email } = user;

const numbers = [1, 2, 3];
const moreNumbers = [...numbers, 4, 5];

try {
  const result = await fetchData();
  const processed = await processResult(result);
  console.log(processed);
} catch (error) {
  console.error(error);
}
```

**Why**: Modern syntax is more concise, readable, and less error-prone.

---

## Example 9: File Organization

### Bad
```javascript
export function helper2() { }

const CONSTANT_A = 1;

import { utils } from './utils';

function helper1() { }

export class MyClass { }

import React from 'react';

const CONSTANT_B = 2;
```

### Good
```javascript
// Imports
import React from 'react';
import { utils } from './utils';

// Constants
const CONSTANT_A = 1;
const CONSTANT_B = 2;

// Helper functions
function helper1() { }
function helper2() { }

// Main exports
export class MyClass { }
```

**Why**: Consistent file organization makes code predictable and easier to navigate.

---

## Example 10: Function Documentation

### Bad
```javascript
// Calculate price
function calc(items, tax, discount) {
  let total = 0;
  for (let i = 0; i < items.length; i++) {
    total += items[i].price;
  }
  total = total * (1 + tax);
  total = total - discount;
  return total;
}
```

### Good
```javascript
/**
 * Calculates the final price including tax and discount
 *
 * @param {Array<Item>} items - Array of items with price property
 * @param {number} tax - Tax rate as decimal (e.g., 0.08 for 8%)
 * @param {number} discount - Fixed discount amount to subtract
 * @returns {number} Final price after tax and discount
 *
 * @example
 * const items = [{ price: 10 }, { price: 20 }];
 * const final = calculateFinalPrice(items, 0.08, 5);
 * // Returns: 27.4 (30 * 1.08 - 5)
 */
function calculateFinalPrice(items, tax, discount) {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  const withTax = subtotal * (1 + tax);
  return withTax - discount;
}
```

**Why**: Good documentation and clear naming eliminate need for explanatory comments.

---

## Example 11: Object and Array Manipulation

### Bad
```javascript
var user = { name: 'John', age: 30 };
var updatedUser = user;
updatedUser.age = 31;  // Mutates original

var arr = [1, 2, 3];
arr.push(4);  // Mutates original
```

### Good
```javascript
const user = { name: 'John', age: 30 };
const updatedUser = { ...user, age: 31 };  // Immutable update

const arr = [1, 2, 3];
const newArr = [...arr, 4];  // Immutable addition
```

**Why**: Immutable patterns prevent unexpected side effects and make code easier to reason about.

---

## Example 12: Boolean Expressions

### Bad
```javascript
if (user !== null && user !== undefined) {
  // Do something
}

const isValid = value === true ? true : false;

if (items.length > 0) {
  return true;
} else {
  return false;
}
```

### Good
```javascript
if (user != null) {  // Checks both null and undefined
  // Do something
}

const isValid = Boolean(value);

return items.length > 0;
```

**Why**: Simpler boolean logic is easier to understand and less error-prone.

---

## Summary

**Key Principles**:
1. **Consistency** - Follow the same patterns throughout
2. **Readability** - Code is read more than written
3. **Simplicity** - Prefer clear over clever
4. **Modern** - Use current language features
5. **Explicit** - Make intentions clear

**Remember**: These are guidelines, not absolute rules. Consistency within a project is more important than perfect adherence to any style guide.
