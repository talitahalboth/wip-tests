# wip-tests

A simple calculator implementation in JavaScript with comprehensive tests.

## Features

- Basic arithmetic operations: addition, subtraction, multiplication, and division
- Error handling for division by zero
- Comprehensive test coverage with Jest

## Installation

```bash
npm install
```

## Usage

Run the calculator demo:

```bash
npm start
```

Or use it programmatically:

```javascript
const { add, subtract, multiply, divide } = require('./calculator');

console.log(add(5, 3));        // Output: 8
console.log(subtract(10, 4));  // Output: 6
console.log(multiply(6, 7));   // Output: 42
console.log(divide(20, 4));    // Output: 5
```

## Testing

Run the test suite:

```bash
npm test
```

## License

MIT