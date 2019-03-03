
export function isLeapYear(year) {
    return year % 400 == 0 || year % 100 != 0 && year % 4 == 0;
}

export function daysInMonth(year, month) {
    let days = null;
    if (month >= 1 && month <= 12) {
        switch (month) {
        case 1:
            days = 31;
            break;
        case 2:
            days = isLeapYear(year) ? 29 : 28;
            break;
        case 3:
            days = 31;
            break;
        case 4:
            days = 30;
            break;
        case 5:
            days = 31;
            break;
        case 6:
            days = 30;
            break;
        case 7:
            days = 31;
            break;
        case 8:
            days = 31;
            break;
        case 9:
            days = 30;
            break;
        case 10:
            days = 31;
            break;
        case 11:
            days = 30;
            break;
        case 12:
            days = 31;
            break;
        }
    }
    return days;
}

export function dayNumber(year, month, day) {
    let dayNum = null;
    if (month >= 1 && month <= 12) {
        for (let i = 1; i < month; i++) {
            dayNum = dayNum + daysInMonth(year, i);
        }
        dayNum = dayNum + day;
    }
    return dayNum;
}

export function weekNumber(year, month, day) {
    return Math.floor(dayNumber(year, month, day) / 7) + 1;
}

