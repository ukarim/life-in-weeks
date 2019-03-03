
import { weekNumber } from './date_util.js';
import { createElement, addEvent } from './dom_util.js';

const appRoot = document.getElementById('app');

const birthdayForm = createElement('form');

addEvent(birthdayForm, 'submit', (e) => {
    e.preventDefault();
    let birthdayValue = document.getElementById('birthday-input').value;
    let node = document.getElementById('calendar-wrapper');
    renderCalendar(node, birthdayValue);
    if (window.localStorage) {
        window.localStorage.setItem('birthday', birthdayValue);
    }
});

const birthdayInput = createElement('input', 'birthday-input');
birthdayInput.setAttribute('placeholder', 'yyyy-mm-dd');

const submitButton = createElement('input', null, ['submit-button']);
submitButton.setAttribute('type', 'submit');
submitButton.setAttribute('value', 'show calendar');

const calendarWrapper = createElement('div');
calendarWrapper.setAttribute('id', 'calendar-wrapper');

birthdayForm.appendChild(birthdayInput);
birthdayForm.appendChild(submitButton);

appRoot.appendChild(birthdayForm);
appRoot.appendChild(calendarWrapper);


if (window.localStorage) {
    let savedBirthday = window.localStorage.getItem('birthday');

    if (savedBirthday) {
        birthdayInput.value = savedBirthday;
        renderCalendar(calendarWrapper, savedBirthday);
    }
}

function renderCalendar(node, birthdayValue) {

    let birthDate = new Date(Date.parse(birthdayValue));

    let day = birthDate.getDate();
    let month = birthDate.getMonth() + 1;
    let year = birthDate.getFullYear();

    let currentDate = new Date();
    let currentDay = currentDate.getDate();
    let currentMonth = currentDate.getMonth() + 1;
    let currentYear = currentDate.getFullYear();

    let birthWeek = weekNumber(year, month, day);
    let currentWeek = weekNumber(currentYear, currentMonth, currentDay);

    let calendarContainer = createElement('div');

    for (let i = year; i < year + 80; i++) {

        let y = createElement('span', null, null, i + ' ');
        calendarContainer.appendChild(y);
        
        for (let j = 1; j < 53; j++) {
            let weekCell = createElement('div', null, ['week-cell']);

            if (i >= year && i <= currentYear && !(i == year && j < birthWeek || i == currentYear && j >= currentWeek)) {
                weekCell.classList.add('colored-cell');
            }
            calendarContainer.appendChild(weekCell);
        }

        calendarContainer.appendChild(createElement('br'));
    }
    while (node.firstChild) {
        node.innerHTML = '';
    }
    node.appendChild(calendarContainer);
}

