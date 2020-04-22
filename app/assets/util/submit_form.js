function serializeQueryParams(formData) {
  return Array.from(formData).map(
    (param) => `${encodeURIComponent(param[0])}=${encodeURIComponent(param[1])}`
  ).join('&');
}

export default function submitForm(formElement, options = {}) {
  const formData = new FormData(formElement);
  let url;
  let body;

  if (formElement.method === 'get') {
    url = `${formElement.action}?${serializeQueryParams(formData)}`;
  } else {
    url = formElement.action;
    body = formData;
  }

  return fetch(url, {
    method: formElement.method,
    body,
    credentials: 'include',
    ...options
  });
}
