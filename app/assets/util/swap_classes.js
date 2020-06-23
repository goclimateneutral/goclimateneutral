
export function swapToActiveClassList(element) {
  if (element.dataset.inactiveClass === undefined) {
    element.dataset.inactiveClass = element.className;
  }

  element.className = element.dataset.activeClass;
}

export function swapToInactiveClassList(element) {
  element.className = element.dataset.inactiveClass;
}
