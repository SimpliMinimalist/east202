# Project Blueprint

## Overview

A Flutter application for managing products and orders.

## Project Structure

The project follows a feature-based folder structure.

-   `lib/features/auth`: Authentication-related features.
-   `lib/features/orders`: Order management features.
    -   `lib/features/orders/search_orders`: Search functionality for orders.
-   `lib/features/profile`: User profile management.
-   `lib/features/store`: Store management features.
    -   `lib/features/store/add_product`: Feature for adding and editing products.
    -   `lib/features/store/providers`: Contains providers for the store feature.
    -   `lib/features/store/search_product`: Feature for searching products.
    -   `lib/features/store/store_setup`: Feature for setting up the store.

## Features Implemented

### Add/Edit Product Screen
-   Allows creating and editing products.
-   Image picker for adding up to 10 product images.
-   Fields for product name, price, category, stock, and description.
-   Ability to add product variants.
-   Draft saving functionality.
-   Sale price functionality with a dedicated bottom sheet widget (`SalePriceBottomSheet`).
-   Display of the original price with a strikethrough when a sale price is active.
-   "Add discount" button is disabled until a valid price is entered.
-   "Add discount" button text changes to "Edit discount" when a sale price is active.
-   Sale price input validation to ensure the sale price is less than the original price.
-   The "Done" button in the sale price bottom sheet is disabled if the validation fails.
-   The sale price is automatically cleared if the bottom sheet is dismissed with an invalid value.
-   The sale price bottom sheet is scroll-controlled to avoid keyboard overlap.
- Corrected a typo from `_edited` to `_editedProduct`

## Current Change: Refactor and Enhance Sale Price Input

-   **Goal:** Improve the sale price input functionality by refactoring it into a separate widget and enhancing its validation logic.
-   **Steps:**
    1.  Created a new widget `SalePriceBottomSheet` in `lib/features/store/add_product/widgets/sale_price_bottom_sheet.dart`.
    2.  The new widget encapsulates the sale price input and validation logic.
    3.  Updated `add_product_screen.dart` to use the new `SalePriceBottomSheet` widget.
    4.  Implemented validation to ensure the sale price is less than the original price.
    5.  Disabled the "Done" button in the bottom sheet when the input is invalid.
    6.  Added logic to clear the sale price if the bottom sheet is dismissed with an invalid value.
