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
-   Character limit for product name and description fields is only shown on focus.
-   Ability to add product variants.
-   The master price and stock fields are hidden when product variants are added.
-   "Add Product Variants" button width is now based on its content and centered.
-   The icon for the "Add Product Variants" button changes from an add icon to an edit icon when variants are present.
-   Draft saving functionality.
-   Sale price functionality with a dedicated bottom sheet widget (`SalePriceBottomSheet`).
-   Display of the original price with a strikethrough when a sale price is active.
-   The strikethrough line and the text color for the original price are now the same.
-   "Add discount" button is disabled until a valid price is entered.
-   "Add discount" button text changes to "Edit discount" when a sale price is active.
-   Sale price input validation to ensure the sale price is less than the original price.
-   The "Done" button in the sale price bottom sheet is disabled if the validation fails.
-   The sale price is automatically cleared if the bottom sheet is dismissed with an invalid value.
-   The sale price bottom sheet is scroll-controlled to avoid keyboard overlap.
-   Corrected a typo from `_editedDitedProduct` to `_editedProduct`.
-   Preserves existing variant data when editing variants.

### Add Variants Screen

-   The "Save" button has been moved from the app bar to a bottom navigation bar for a consistent user experience.

### Edit Variant Screen

-   **Delete Functionality**: Added a delete icon to the app bar. Tapping the icon shows a confirmation dialog before deleting the variant.
-   The "Save" button has been moved from the app bar to a bottom navigation bar, matching the design of the "Add Variants" and "Add Product" screens.
-   Reuses the `PriceInputField` from the add product screen, allowing for sale prices on individual variants.
-   Manages state for sale price, including the discount percentage calculation.
-   Uses the `SalePriceBottomSheet` for a consistent editing experience.
-   **Error Handling**: Displays an error message if the user tries to save without adding an image or a price.
-   **Empty Default Fields**: The price and stock fields are now initialized as empty strings if their initial values are 0, preventing the display of "0.00" or "0" by default.

### Variant List UI
-   **Delete Functionality**: Added a delete icon to each variant card, allowing for quick deletion from the list.
-   Removed the shadow effect from the variant cards in the product details screen.
-   Added a light border to maintain visual separation between the cards.
-   Displays the variant's image in the list.
-   **Displays the sale price, original price with strikethrough, and discount percentage in the `VariantsList` widget when a sale price is active.**

### Category Field UI Fix
-   Corrected the height and alignment of the "Category" input field to match other text fields and ensure it expands dynamically as category chips are added.
-   Replaced the previous implementation with a `TextFormField` wrapped in a `GestureDetector` and an `AbsorbPointer`.
-   The `TextFormField` is set to `readOnly: true` and acts as a styled container.
-   The `Wrap` widget containing the category `Chip`s is placed inside the `prefixIcon` property of the `InputDecoration`.
-   Fixed a typo from `Listile` to `ListTile` in the category picker bottom sheet.

### Category Chip UI
-   Reduced the height of the category chips to make them more compact.

### Variant Image Picker
-   Allows users to add an image to each product variant.
-   Refactored `ProductImageHandler` to support a variable number of images and display error messages.
-   Updated the `maxImages` for the main product to 10 and for variants to 4.
-   Integrated into `EditVariantScreen` to allow picking up to 4 images for a variant.

### Shared Widgets
-   **`ClearableTextFormField`**: Added an `errorText` parameter to allow displaying validation errors.
-   **`PriceInputField`**: Updated to accept and display an `errorMessage`.
-   **`ProductImageHandler`**: Added an `isVariantGallery` property to change the UI and behavior when displaying variant images.

### Variant Image Gallery and Data Model Fixes

-   **Goal:** Implement a read-only image gallery on the main product page that displays all variant images. This involved fixing the product variant data model and updating all related widgets.
-   **Steps:**
    1.  **`product_variant_model.dart`:** Changed the `image` property from `String?` to `List<String> images` to support multiple images per variant.
    2.  **`edit_variant_screen.dart`:** Updated the screen to use the new `images` list, allowing users to add, remove, and save multiple images.
    3.  **`add_product_screen.dart`:** Implemented the `_getVariantImages` method to aggregate images from all variants. The `ProductImageHandler` now displays these images in a read-only gallery view when variants are present.
    4.  **`variants_list.dart`:** Fixed the widget to display the first image from the `images` list as the variant thumbnail.

### Real-time Variant Image Deletion

-   **Goal:** Enable real-time, synchronous deletion of variant images from the aggregated gallery view on the main product page.
-   **Steps:**
    1.  **`product_image_handler.dart`:**
        -   Added a new optional callback function, `onImageDeleted`, which is triggered when an image is removed.
        -   The `_removeImage` function now calls `onImageDeleted` if it's provided, allowing the parent widget to handle the deletion logic. Otherwise, it updates its internal state as before.
    2.  **`add_product_screen.dart`:**
        -   Implemented the `onImageDeleted` callback in the `ProductImageHandler` for the variant image gallery.
        -   Created a `_deleteVariantImage` method that finds the correct product variant and removes the specified image from its `images` list.
        -   This ensures that deleting an image from the main gallery immediately updates the underlying data model and refreshes the UI.

### Variant Image Label UI Refinement

-   **Goal:** Improve the UI of the variant image labels.
-   **Steps:**
    1.  **Display Variant Values:**
        -   **`product_image_handler.dart`:** Added an optional `imageLabels` parameter to display variant values in the image gallery.
        -   **`add_product_screen.dart` & `edit_variant_screen.dart`:** Updated to provide the appropriate labels to the `ProductImageHandler`.
    2.  **Adjust Label Width:**
        -   **`product_image_handler.dart`:** Modified the layout to ensure the label's background width fits the text content, preventing it from expanding to the full width of the image.

## Current Change: Fix Variant Deletion Logic

-   **Goal:** Correctly handle variant deletion to prevent deleted variants from reappearing and resolve related errors.
-   **Steps:**
    1.  **`variant_model.dart`:** Added a `copyWith` method to the `VariantOption` class to resolve an `undefined_method` error.
    2.  **`add_product_screen.dart`:**
        -   Corrected the logic in the `_deleteVariant` method to properly update the underlying variant options.
        -   Fixed null-check errors that were occurring during the deletion process.
    3.  **Analysis and Verification:** Ran `analyze_files` to ensure all errors were resolved.
    4.  **Update `blueprint.md`:** Documented the bug fix and the steps taken to resolve the errors.
    5.  **Commit and Push:** Committing the final, corrected code to the repository.
