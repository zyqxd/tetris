import * as React from 'react';
import ReactDOM from 'react-dom';

const App = () => {
  return (
    <div>
      <h1>Hey!</h1>
      <div>Finally got this to work</div>
      <div>And it'll refresh?</div>
    </div>
  );
}

ReactDOM.render(
  <App />,
  document.getElementById('react-root')
);
