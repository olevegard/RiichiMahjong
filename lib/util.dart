class MathUtil{

    static num min3(num num1, num num2, num num3) {
        if (num1 <= num2 && num1 <= num3) {
            return num1;
        }

        if (num2 <= num1 && num2 <= num3) {
            return num2;
        }


        if (num3 <= num1 && num3 <= num2) {
            return num3;
        }

        return num1;
    }
}
