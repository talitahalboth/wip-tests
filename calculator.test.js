/**
 * Unit tests for the calculator module.
 */

const { add, subtract, multiply, divide } = require('./calculator');

describe('Calculator', () => {
  describe('add', () => {
    test('adds two positive numbers', () => {
      expect(add(2, 3)).toBe(5);
    });

    test('adds negative and positive number', () => {
      expect(add(-1, 1)).toBe(0);
    });

    test('adds two zeros', () => {
      expect(add(0, 0)).toBe(0);
    });
  });

  describe('subtract', () => {
    test('subtracts two positive numbers', () => {
      expect(subtract(10, 5)).toBe(5);
    });

    test('subtracts larger from smaller', () => {
      expect(subtract(0, 5)).toBe(-5);
    });

    test('subtracts equal numbers', () => {
      expect(subtract(5, 5)).toBe(0);
    });
  });

  describe('multiply', () => {
    test('multiplies two positive numbers', () => {
      expect(multiply(3, 4)).toBe(12);
    });

    test('multiplies negative and positive', () => {
      expect(multiply(-2, 5)).toBe(-10);
    });

    test('multiplies by zero', () => {
      expect(multiply(0, 100)).toBe(0);
    });
  });

  describe('divide', () => {
    test('divides two positive numbers', () => {
      expect(divide(10, 2)).toBe(5);
    });

    test('divides evenly', () => {
      expect(divide(9, 3)).toBe(3);
    });

    test('divides negative by positive', () => {
      expect(divide(-10, 2)).toBe(-5);
    });

    test('throws error when dividing by zero', () => {
      expect(() => divide(10, 0)).toThrow("Cannot divide by zero");
    });
  });
});
