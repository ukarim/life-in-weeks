
export function createElement(tagName, id, classNames, textContent) {
    let el = document.createElement(tagName);
    if (id) {
        el.setAttribute('id', id);
    }
    if (classNames) {
        for (let i = 0; i < classNames.length; i++) {
            el.classList.add(classNames[i]);
        }
    }
    if (textContent) {
        el.innerText = textContent;
    }
    return el;
}

export function addEvent(node, event, handler) {
    if (node.addEventListener) {
        node.addEventListener(event, handler, false);
        
    } else if (node.attachEvent) {
        node.attachEvent('on' + event, handler);
        
    } else {
        event = 'on' + event;
        if (typeof node[event] === 'function') {
            handler = (function(f1, f2) {
                return function() {
                    f1.apply(this, arguments);
                    f2.apply(this, arguments);
                }
            })(node[event], handler);
        }
        node[event] = handler;
    }
}

