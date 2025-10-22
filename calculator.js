/**
 * Simple calculator module with basic arithmetic operations.
 */

/**
 * Add two numbers and return the result.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} The sum of a and b
 */
function add(a, b) {
  return a + b;
}

/**
 * Subtract b from a and return the result.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} The difference of a and b
 */
function subtract(a, b) {
  return a - b;
}

/**
 * Multiply two numbers and return the result.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} The product of a and b
 */
function multiply(a, b) {
  return a * b;
}

/**
 * Divide a by b and return the result.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} The quotient of a and b
 * @throws {Error} If b is zero
 */
function divide(a, b) {
  if (b === 0) {
    throw new Error("Cannot divide by zero");
  }
  return a / b;
}

/**
 * Demo function to show calculator usage.
 */
function main() {
  console.log("Calculator Demo");
  console.log("=".repeat(40));
  console.log(`5 + 3 = ${add(5, 3)}`);
  console.log(`10 - 4 = ${subtract(10, 4)}`);
  console.log(`6 * 7 = ${multiply(6, 7)}`);
  console.log(`20 / 4 = ${divide(20, 4)}`);
  console.log("=".repeat(40));
}

// Run demo if this is the main module
if (require.main === module) {
  main();
}

// Export functions for testing
module.exports = { add, subtract, multiply, divide };
