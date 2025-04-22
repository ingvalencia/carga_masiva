import { createRoot } from 'react-dom/client';
import ExcelUploader from './components/ExcelUploader';
import PersonasTable from './components/PersonasTable';
import 'bootstrap/dist/css/bootstrap.min.css';
import "bootstrap-icons/font/bootstrap-icons.css";

const container = document.getElementById('root');
const root = createRoot(container);
root.render(
  <div className="container mt-4">
    <ExcelUploader />
    <PersonasTable />
  </div>
);
